import 'dart:convert';

import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/database/database_handler.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/transactions/guest_transaction_model.dart';
import 'package:airtimeslot_app/screens/transaction/transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import "package:collection/collection.dart";

import 'components/transaction_row.dart';

class MyTransactions extends StatefulWidget {
  final PreferenceManager? manager;
  final List<GuestTransactionModel> guestModel;
  final List<dynamic> model;
  const MyTransactions({
    Key? key,
    this.manager,
    required this.guestModel,
    required this.model,
  }) : super(key: key);

  @override
  State<MyTransactions> createState() => _MyTransactionsState();
}

class _MyTransactionsState extends State<MyTransactions> {
  final _searchController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _refreshController = RefreshController(initialRefresh: false);

  var _filtered = [];
  bool _isLoaded = false, isSpinning = false;
  var _allMeals;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  List<dynamic> _list = [];
  int _currentPage = 1;
  List<Widget> _mWidgets = [];
  bool _hasMoreTransactions = false;

  void _paginateTransaction() async {
    final _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("accessToken") ?? "";
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        debugPrint("reached end");

        //Now load more items
        if (_controller.isMoreDataAvailable.value) {
          _controller.isDataProcessing.value = true;
          _currentPage++;
          Future.delayed(const Duration(seconds: 3), () {
            APIService()
                .getTransactionsPaginated(_token, _currentPage)
                .then((value) {
              _controller.isDataProcessing.value = false;
              Map<String, dynamic> map = jsonDecode(value.body);

              debugPrint("PAGIN:  ${map['data']}");
              setState(() {
                _controller.isMoreDataAvailable.value =
                    map['data']['next_page_url'] == null ? false : true;
                _list.addAll(map['data']['data']);
              });
            });
          });
        } else {
          _controller.isDataProcessing.value = false;
          Constants.toast("All transactions loaded");
        }
      } else {
        debugPrint("still moving to end");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _paginateTransaction();
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: "en", allowFromNow: true);
  }

  List<Widget> _buildList() {
    List<Widget> _widg = [];
    Map<String?, List<dynamic>> groupByDate =
        groupBy(_list, (dynamic obj) => obj['created_at']?.substring(0, 10));

    groupByDate.forEach((date, list) {
      // print("$date");

      // Group
      var _wid = Column(
        children: [
          Container(
            color: Constants.accentColor,
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: TextPoppins(
              text: DateFormat.yMMMEd('en_US').format(DateTime.parse("$date")),
              fontSize: 17,
              align: TextAlign.center,
              fontWeight: FontWeight.w600,
              color: Constants.primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => TextButton(
              onPressed: () {
                showBarModalBottomSheet(
                  expand: false,
                  context: context,
                  topControl: ClipOval(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: TransactionDetails(
                      model: list[i],
                      guestModel: null,
                      manager: widget.manager!,
                    ),
                  ),
                );
              },
              child: TransactionRow(
                model: list[i],
                guestModel: null,
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
              ),
            ),
            separatorBuilder: (context, i) => const Divider(),
            itemCount: list.length,
          ),
          const SizedBox(height: 16.0),
        ],
      );

      _widg.add(_wid);
    });

    return _widg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16.0,
            ),
            ClipOval(
              child: Center(
                child: ClipOval(
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
            ),
            const SizedBox(
              width: 4.0,
            ),
          ],
        ),
        title: TextPoppins(
          text: "My Transactions".toUpperCase(),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        centerTitle: true,
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
      body: FutureBuilder<http.Response>(
        future:
            APIService().getTransactions("${widget.manager?.getAccessToken()}"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(
                16.0,
              ),
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(
                16.0,
              ),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Image.asset(
                  "assets/images/no_record.png",
                  width: 256,
                ),
              ),
            );
          }

          http.Response data = snapshot.requireData;
          Map<String, dynamic> map = jsonDecode(data.body);
          _list = map['data']['data'];
          // _hasMoreTransactions =
          //     map['data']['next_page_url'] == null ? false : true;
          //  if (mounted) {

          //  }
          // print("DATA NNH <<<<>>>> ${map['data']}");

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _refreshHome,
            enablePullDown: true,
            enablePullUp: false,
            header: const WaterDropMaterialHeader(
              color: Constants.accentColor,
              backgroundColor: Constants.primaryColor,
            ),
            child: Obx(
              () => ListView(
                shrinkWrap: true,
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                children: [
                  Column(
                    children: _buildList(),
                  ),
                  _controller.isDataProcessing.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        },
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
        _list.clear();

        final resp = APIService().getTransactions(_token).then((value) {
          Map<String, dynamic> map = jsonDecode(value.body);
          setState(() {
            _list = map['data']['data'];
          });
        });

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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
