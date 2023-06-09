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

class Pay extends StatefulWidget {
  final PreferenceManager? manager;
  const Pay({
    Key? key,
    this.manager,
  }) : super(key: key);

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
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
      backgroundColor: Constants.accentColor,
      body: Column(
        children: [
          const SizedBox(height: 48),
          Stack(
            children: [
              Center(
                child: TextRoboto(
                  text: "Pay",
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                left: 16.0,
                top: 1,
                bottom: 21,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Constants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36.0),
          Expanded(
            child: Card(
              color: Colors.white.withOpacity(.9),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recharge & Pay Bills",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Constants.primaryColor,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/images/internet_access_icon.svg",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextRoboto(
                                          text: "Internet Data",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const Text(
                                          "Best rates on data purchase",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(2.0),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Constants.primaryColor,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/images/phone_call_icon.svg",
                                            width: 21,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextRoboto(
                                          text: "Airtime Topup",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const Text(
                                          "Recharge any phone easily",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(2.0),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Constants.primaryColor,
                                        padding: const EdgeInsets.all(8.0),
                                        width: 36,
                                        height: 36,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/images/hand_exchange_money.svg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextRoboto(
                                          text: "Airtime to Cash",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const Text(
                                          "Convert airtime to cash easily",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(2.0),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Constants.primaryColor,
                                        padding: const EdgeInsets.all(8.0),
                                        width: 36,
                                        height: 36,
                                        child: Center(
                                          child: Image.asset(
                                            "assets/images/bill_icon.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextRoboto(
                                          text: "Bill Payment",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const Text(
                                          "All utility bills payment",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(2.0),
                              foregroundColor: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 21.0),
                  ],
                ),
              ),
            ),
          ),
        ],
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
