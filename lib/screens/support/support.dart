import 'dart:convert';

import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/database/database_handler.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/transactions/guest_transaction_model.dart';
import 'package:airtimeslot_app/screens/services/airtime/airtime.dart';
import 'package:airtimeslot_app/screens/services/bill_payment.dart';
import 'package:airtimeslot_app/screens/services/bill_payment.dart';
import 'package:airtimeslot_app/screens/services/data/internet_data.dart';
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


class Support extends StatefulWidget {
  final PreferenceManager? manager;
  const Support({
    Key? key,
    this.manager,
  }) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final _searchController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _refreshController = RefreshController(initialRefresh: false);

  var _filtered = [];
  bool _isLoaded = false, isSpinning = false;
  var _allMeals;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();



  @override
  void initState() {
    super.initState();
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
                  text: "Help center",
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              Text(
                                "Tell us how we can help",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Our crew are standing by for \nservice and support",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextButton(
                          onPressed: () {
                            // Get.to(
                            //   const InternetData(),
                            //   transition: Transition.cupertino,
                            // );
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
                                        text: "Call us",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Text(
                                        "Quick response over the phone",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
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
                                        text: "Email",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Text(
                                        "Get a solution beamed to your inbox",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
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
