import 'dart:convert';

import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/screens/services/airtime/airtime.dart';
import 'package:data_extra_app/screens/services/airtime/airtime_cash.dart';
import 'package:data_extra_app/screens/services/airtime_swap.dart';
import 'package:data_extra_app/screens/services/bill_payment.dart';
import 'package:data_extra_app/screens/services/data/internet_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  final _controller = Get.find<StateController>();
  final _refreshController = RefreshController(initialRefresh: false);

  bool _isLoaded = false, isSpinning = false;

  final _scrollController = ScrollController();

  List<dynamic> _list = [];
  int _currentPage = 1;
  bool _hasMoreTransactions = false;

  void _paginateTransaction() async {
    final _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("accessToken") ?? "";
    if (_token.isNotEmpty) {
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
  }

  @override
  void initState() {
    super.initState();
    _paginateTransaction();
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: "en", allowFromNow: true);
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Recharge & Pay Bills",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              InternetData(
                                manager: widget.manager!,
                              ),
                              transition: Transition.cupertino,
                            );
                          },
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 21.0,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 21.0,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 21.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              BillPayment(
                                manager: widget.manager!,
                              ),
                              transition: Transition.cupertino,
                            );
                          },
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: Colors.black,
                          ),
                        )
                      ],
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
