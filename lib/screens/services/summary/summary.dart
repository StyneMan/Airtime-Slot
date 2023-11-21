import 'dart:convert';

import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/screens/history/history_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransactionSummary extends StatelessWidget {
  final String type;
  var data;
  final PreferenceManager manager;
  TransactionSummary({
    Key? key,
    required this.type,
    required this.data,
    required this.manager,
  }) : super(key: key);

  final _controller = Get.find<StateController>();

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: "en", allowFromNow: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        backgroundColor: Colors.black54,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        child: Scaffold(
          backgroundColor: Constants.accentColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: TextPoppins(
                      text: type.capitalize,
                      fontSize: 21,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Positioned(
                    left: 8.0,
                    top: -5,
                    bottom: -5,
                    child: Center(
                      child: ClipOval(
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Constants.primaryColor,
                          ),
                        ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: const [
                                  Text(
                                    "Transaction Summary",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Here are vital information about your transaction",
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
                              height: 21.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Type",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${data['type']}".capitalize!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Amount",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoney(int.parse("${data['amount'] ?? "0"}"))}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Reference",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${data['transaction_ref']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Email address",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${data['email']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Discount",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${data['discount_text']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            data['type'] == "electricity" &&
                                    data['transaction_meta']['meter_type'] ==
                                        "prepaid" &&
                                    "${data['transaction_meta']['purchased_token']}"
                                            .toLowerCase() !=
                                        "null"
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          TextPoppins(
                                            text: "Token",
                                            fontSize: 14,
                                          ),
                                          Text(
                                            "${data['transaction_meta']['purchased_token']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Initiated on",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['created_at']))} (${timeUntil(DateTime.parse("${data['created_at']}"))})"
                                      .replaceAll("about", "")
                                      .replaceAll("minute", "min"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Status",
                                  fontSize: 14,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: data['status'] == "initiated"
                                            ? Colors.amber
                                            : data['status'] == "success"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(
                                      "${data['status']}".capitalize!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.11,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.98,
                          child: RoundedButton(
                            text: "Continue",
                            press: () {
                              _payWallet();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _payWallet() async {
    _controller.setLoading(true);
    Map _payload = {
      "method": "wallet",
      "transaction_ref": "${data['transaction_ref']}",
      "wallet_pin": "0000"
    };
    try {
      final resp =
          await APIService().payment(_payload, manager.getAccessToken());
      debugPrint("WALLET PAYMENT RESP>> ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast("Transaction completed successfully");

        _controller.onInit();
        _controller.transactions.value = [];
        await APIService().fetchTransactions(manager.getAccessToken());

        // Get.back();
        // Get.back();

        //Go to transaction info screen
        Get.to(
          HistoryDetail(
            data: map['data']['transaction'],
            caller: "summary",
          ),
          transition: Transition.cupertino,
        );
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        Constants.toast(errorMap['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }
}
