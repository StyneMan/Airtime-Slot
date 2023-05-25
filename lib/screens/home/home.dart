import 'dart:convert';

import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/glassmorphism/glass_card.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/database/database_handler.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/transactions/guest_transaction_model.dart';
import 'package:airtimeslot_app/model/transactions/user/user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/others_section.dart';
import 'components/recent_transactions.dart';
import 'components/recharge_section.dart';

class Home extends StatefulWidget {
  final PreferenceManager? manager;
  const Home({Key? key, this.manager}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  String _bal = "0.00", _email = "";
  String _name = "Guest User";
  bool _isAuthenticated = false;
  final _refreshController = RefreshController(initialRefresh: false);

  final List<UserTransaction> _transactionList = [];
  List<GuestTransactionModel> _transactionListGuest = [];

  // Widget _mWidget = const SizedBox();
  // Widget _nWidget = const SizedBox();

  _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('loggedIn') ?? false;
      final String _token = prefs.getString('accessToken') ?? "";
      // var model = prefs.get('user');
      // if (model != null) {
      var mod = widget.manager!.getUser();
      debugPrint("APROKO:: ${mod['name']}");
      setState(() {
        _bal = mod['wallet_balance']!;
        _name = mod['name'];
        _email = mod['email'];
      });
      // }

      if (_isAuthenticated) {
        var data = _controller.transactions.value;
        // print("MJKD::: ${data}");
        for (var v in data) {
          _transactionList.add(UserTransaction.fromJson(v));
        }
      } else {
        //Fetch from sqlite
        final resp = await DatabaseHandler().transactions();
        setState(() {
          _transactionListGuest = resp;
        });
      }
      await APIService()
          .getTransactions(_token)
          .then((value) => debugPrint("JUST Refetching: : ${value.body}"));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  String _currentMonth() {
    List<String> _months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    var now = DateTime.now();
    return _months[now.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.white,
        backgroundColor: Constants.primaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: SvgPicture.asset(
                    "assets/images/personal_icon.svg",
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            RichText(
              text: TextSpan(
                text: "Hi, ",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: _name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (!_scaffoldKey.currentState!.isEndDrawerOpen) {
                _scaffoldKey.currentState!.openEndDrawer();
              }
            },
            icon: SvgPicture.asset(
              'assets/images/menu_icon.svg',
              color: Colors.white,
            ),
          ),
        ],
      ),
      endDrawer: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: CustomDrawer(
          manager: widget.manager!,
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _refreshHome,
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropMaterialHeader(
          color: Constants.accentColor,
          backgroundColor: Constants.primaryColor,
        ),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Constants.primaryColor,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Image.asset(
                        "assets/images/glass_bg2.jpeg",
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 1,
                    right: 1,
                    child: GlassCard(
                      manager: widget.manager!,
                      walletBalance: _bal,
                      email: _email,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 21.0,
                  ),
                  RechargeSection(
                    manager: widget.manager!,
                    isAuthenticated: _isAuthenticated,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: Constants.accentColor,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  _name == "Guest User"
                      ? const SizedBox()
                      : OthersSection(manager: widget.manager!),
                  const SizedBox(
                    height: 18,
                  ),
                  RecentTransactions(
                    manager: widget.manager!,
                    isAuthenticated: _isAuthenticated,
                  ),
                  const SizedBox(
                    height: 21.0,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 56.0,
            ),
          ],
        ),
      ),
    );
  }

  _refreshHome() async {
    _controller.setLoading(true);
    _refreshController.requestRefresh();

    //Update user data
    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      if (_token.isNotEmpty) {
        final userResp = await APIService().getProfile(_token);
        debugPrint("USER PROFILE ::: ${userResp.body}");

        if (userResp.statusCode == 200) {
          Map<String, dynamic> userMap = jsonDecode(userResp.body);

          String userData = jsonEncode(userMap['data']);
          widget.manager?.updateUserData(userData);
        } else {}

        // _controller.setRecentTransactions([]);
        _controller.recentTransactions.value = [];
        _controller.transactions.value = [];

        await Future.delayed(
          const Duration(seconds: 2),
          () {
            APIService().fetchTransactions(_token);
          },
        );

        Future.delayed(
          const Duration(seconds: 3),
          () {
            _controller.setLoading(false);
            _refreshController.refreshCompleted();
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
      _refreshController.refreshFailed();
    }
  }
}
