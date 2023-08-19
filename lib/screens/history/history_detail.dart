import 'dart:convert';

import 'package:airtimeslot_app/components/dialogs/action_dialog.dart';
import 'package:airtimeslot_app/components/dialogs/info_dialog.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryDetail extends StatefulWidget {
  var data;
  String caller;
  HistoryDetail({Key? key, required this.data, this.caller = ""})
      : super(key: key);

  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
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
                      text: "Transaction Detail",
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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
                            if (widget.caller == "summary") {
                              Get.back();
                              Get.back();
                              Get.back();
                            } else {
                              Get.back();
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.data['wallet_log'] == null
                      ? const SizedBox()
                      : Positioned(
                          right: 8.0,
                          top: -5,
                          bottom: -5,
                          child: Center(
                            child: ClipOval(
                              child: IconButton(
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.50,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 21.0,
                                          ),
                                          TextPoppins(
                                            text: "Wallet Log",
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600,
                                            align: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 21.0,
                                          ),
                                          ListView(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(16.0),
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  TextPoppins(
                                                    text: "Amount",
                                                    fontSize: 14,
                                                  ),
                                                  Text(
                                                    "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(widget.data['wallet_log']['amount']))}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  TextPoppins(
                                                    text: "Balance Before",
                                                    fontSize: 14,
                                                  ),
                                                  Text(
                                                    "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(widget.data['wallet_log']['balance_before']))}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  TextPoppins(
                                                    text: "Balance After",
                                                    fontSize: 14,
                                                  ),
                                                  Text(
                                                    "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(widget.data['wallet_log']['balance_after']))}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  TextPoppins(
                                                    text: "Type",
                                                    fontSize: 14,
                                                  ),
                                                  Text(
                                                    "${widget.data['wallet_log']['type']}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.history,
                                  color: Constants.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 24.0),
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
                                  "${widget.data['type']}"
                                      .replaceAll("_", " ")
                                      .capitalize!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
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
                                  "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse('${widget.data['amount']}'))}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Amount Paid",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse('${widget.data['amount_paid']}'))}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
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
                                  "${widget.data['transaction_ref']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
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
                                  "${widget.data['email']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Payment method",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${widget.data['payment_method']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Payment Ref",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${widget.data['payment_ref']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
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
                                  "${widget.data['discount_text']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text: "Initiated on",
                                  fontSize: 14,
                                ),
                                Text(
                                  "${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.data['created_at']))} (${timeUntil(DateTime.parse("${widget.data['created_at']}"))})"
                                      .replaceAll("about", "")
                                      .replaceAll("minute", "min"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            widget.data['type'] == "electricity" &&
                                    widget.data['transaction_meta']
                                            ['meter_type'] ==
                                        "prepaid" &&
                                    "${widget.data['transaction_meta']['purchased_token']}"
                                            ?.toLowerCase() !=
                                        "null"
                                ? Column(
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${widget.data['transaction_meta']['purchased_token']}"
                                                    .capitalize!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                      ClipboardData(
                                                        text:
                                                            "${widget.data['transaction_meta']['purchased_token']}",
                                                      ),
                                                    );
                                                    Constants.toast(
                                                        "Token copied to clipboard");
                                                  },
                                                  icon: const Icon(Icons.copy))
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
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
                                        color: widget.data['status'] ==
                                                "initiated"
                                            ? Colors.amber
                                            : widget.data['status'] == "success"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(
                                      "${widget.data['status']}".capitalize!,
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
                        const SizedBox(
                          height: 24,
                        ),
                        widget.data['status']?.toLowerCase() == "success"
                            ? const SizedBox()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.98,
                                child: RoundedButton(
                                  text: "Pay Now",
                                  press: () {
                                    _completeTransaction();
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

  _completeTransaction() async {
    //Show dialog first
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.98,
          child: ActionDialog(
            message:
                "Are you sure you want to proceed to complete this transaction?",
            action: () {
              _payWallet();
            },
          ),
        );
      },
    );
  }

  _payWallet() async {
    _controller.setLoading(true);
    Map _payload = {
      "method": "wallet",
      "transaction_ref": "${widget.data['transaction_ref']}",
      "wallet_pin": "0000"
    };
    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString('accessToken') ?? "";
      final resp = await APIService().payment(_payload, _token);

      debugPrint("WALLET PAYMENT RESP>> ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(resp.body);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message:
                    "${map['message'] ?? "Transaction completed successfully"}",
              ),
            );
          },
        );
        _controller.onInit();
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: "${errorMap['message']}",
              ),
            );
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }
}
