import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/transactions/user/user_transaction.dart';
import 'package:airtimeslot_app/screens/history/history.dart';
import 'package:airtimeslot_app/screens/services/airtime/airtime.dart';
import 'package:airtimeslot_app/screens/services/airtime/airtime_cash.dart';
import 'package:airtimeslot_app/screens/services/data/internet_data.dart';
import 'package:airtimeslot_app/screens/services/electricity/electricity.dart';
import 'package:airtimeslot_app/screens/services/television/television.dart';
import 'package:airtimeslot_app/screens/wallet/components/bank_option.dart';
import 'package:airtimeslot_app/screens/wallet/fund_wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final PreferenceManager? manager;
  const Home({Key? key, this.manager}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  String _bal = "0.00", _swapBal = "0.0", _email = "";
  String _name = "Guest User";
  bool _isAuthenticated = false;
  bool _isHidden = false;
  final _refreshController = RefreshController(initialRefresh: false);

  final List<UserTransaction> _transactionList = [];

  _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('loggedIn') ?? false;
      final String _token = prefs.getString('accessToken') ?? "";
      // var model = prefs.get('user');
      // if (model != null) {

      if (_token.isNotEmpty) {
        var mod = widget.manager!.getUser();
        // debugPrint("APROKO:: ${mod['name']}");
        setState(() {
          _bal = mod['wallet_balance']!;
          _name = mod['name'];
          _email = mod['email'];
          _swapBal = mod['withdrawable_balance'];
        });
        // }

        if (_isAuthenticated) {
          var data = _controller.transactions.value;
          // print("MJKD::: ${data}");
          for (var v in data) {
            _transactionList.add(UserTransaction.fromJson(v));
          }
        }
        await APIService()
            .getTransactions(_token)
            .then((value) => debugPrint("JUST Refetching: : ${value.body}"));
      }
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
    return Obx(
      () => Scaffold(
        backgroundColor: Constants.backgroundColor,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          foregroundColor: Constants.primaryColor,
          backgroundColor: Constants.backgroundColor,
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
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "${_controller.userData.value['name'].toString().length > 18 ? _controller.userData.value['name'].toString().substring(0, 15) + "..." ?? "Welcome" : _controller.userData.value['name'] ?? "Welcome"}",
                      style: const TextStyle(
                        color: Colors.black,
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
                color: Constants.primaryColor,
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
          child: _controller.products.isEmpty
              ? const LinearProgressIndicator()
              : ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Image.asset(
                                "assets/images/dash_bg.png",
                                fit: BoxFit.cover,
                                height: 220,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            right: 21,
                            child: Image.asset(
                              "assets/images/chip_fade.png",
                              width: 33,
                            ),
                          ),
                          Positioned(
                            top: 48,
                            left: 21,
                            right: 21,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/wallet_icon.svg",
                                              ),
                                              const SizedBox(width: 8.0),
                                              const Text(
                                                "Wallet Balance",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            _isHidden
                                                ? "******"
                                                : "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(_controller.userData.value['wallet_balance'] ?? "0.0"))}",
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 1.0,
                                          ),
                                          Text(
                                            "${_controller.userData.value['email'] ?? "email@domain.com"}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 21.0),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Swap Balance",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            _isHidden
                                                ? "******"
                                                : "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(_controller.userData.value['withdrawable_balance'] ?? "0.0"))}",
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 1.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipOval(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      color: Colors.black,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _isHidden =
                                                                !_isHidden;
                                                          });
                                                        },
                                                        child: Icon(
                                                          _isHidden
                                                              ? CupertinoIcons
                                                                  .eye
                                                              : CupertinoIcons
                                                                  .eye_slash,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 21.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Container(
                                          height: 42,
                                          color: Colors.white,
                                          child: TextButton.icon(
                                            onPressed: () {
                                              Get.to(
                                                FundWallet(
                                                    manager: widget.manager!),
                                                transition:
                                                    Transition.cupertino,
                                              );
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.add_circled_solid,
                                              color: Colors.black,
                                            ),
                                            label: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const SizedBox(
                                                  width: 4.0,
                                                ),
                                                TextRoboto(
                                                  text: "Fund Wallet",
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1.0,
                                                      horizontal: 10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 21.0),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Container(
                                          height: 42,
                                          color: Colors.white,
                                          child: TextButton.icon(
                                            onPressed: () {
                                              Get.to(
                                                WithdrawToBnnk(),
                                                transition:
                                                    Transition.cupertino,
                                              );
                                            },
                                            icon: const Icon(
                                              CupertinoIcons
                                                  .download_circle_fill,
                                              color: Colors.black,
                                            ),
                                            label: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const SizedBox(
                                                  width: 4.0,
                                                ),
                                                TextRoboto(
                                                  text: "Withdraw",
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1.0,
                                                      horizontal: 10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16.0,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 24.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Constants.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(36.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.to(
                                        InternetData(
                                          manager: widget.manager!,
                                        ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/images/internet_icon.svg",
                                              width: 114,
                                              color: Constants.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Text(
                                          "Internet \nData",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(
                                        Airtime(
                                          manager: widget.manager!,
                                        ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/images/phone_icon.svg",
                                              width: 100,
                                              color: Constants.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Text(
                                          "Airtime \nTopup",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(
                                        AirtimeCash(
                                          manager: widget.manager!,
                                        ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/images/hand_exchange_money.svg",
                                              width: 108,
                                              color: Constants.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Text(
                                          "Airtime to \nCash",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 24.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Constants.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(36.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.to(
                                        Television(
                                          manager: widget.manager!,
                                        ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/images/television_icon.svg",
                                              width: 114,
                                              color: Constants.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Text(
                                          "Cable \nTV",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(
                                        Electricity(
                                          manager: widget.manager!,
                                        ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/images/lamp_icon.svg",
                                              width: 100,
                                              color: Constants.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Text(
                                          "Electricity",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(
                                        const History(
                                            // manager: widget.manager!,
                                            ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/images/history.svg",
                                              width: 108,
                                              color: Constants.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Text(
                                          "History",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                  ],
                ),
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

      _controller.onInit();

      if (_token.isNotEmpty) {
        _controller.transactions.value = [];

        await APIService().fetchTransactions(_token);
        // await APIService().
        _controller.getProducts();

        Future.delayed(
          const Duration(seconds: 2),
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
