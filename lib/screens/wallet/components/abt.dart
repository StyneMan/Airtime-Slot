import 'dart:convert';

import 'package:airtimeslot_app/components/dialogs/info_dialog.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/account/components/kyc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:share_plus/share_plus.dart';

class BankTransfer extends StatefulWidget {
  final PreferenceManager manager;
  const BankTransfer({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<BankTransfer> createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {
  final _controller = Get.find<StateController>();

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
            children: [
              const SizedBox(height: 48),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: TextPoppins(
                      text: "Auto Bank Transfer",
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
              const SizedBox(height: 24.0),
              Expanded(
                child: Card(
                  elevation: 0.0,
                  color: Colors.white.withOpacity(.9),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36.0),
                      topRight: Radius.circular(36.0),
                    ),
                  ),
                  child: (_controller.userData.value['accounts'] ?? [])
                              .isEmpty &&
                          (_controller.userData.value['has_kyc'] == true)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextPoppins(
                                text:
                                    "You need to generate a virtual account to proceed",
                                fontSize: 16,
                                align: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              RoundedButton(
                                text: "Generate now",
                                press: () {
                                  _generateAccount();
                                },
                              ),
                            ],
                          ),
                        )
                      : (_controller.userData.value['accounts'] ?? [])
                                  .isEmpty &&
                              (_controller.userData.value['has_kyc'] == false)
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextPoppins(
                                    text:
                                        " In line with CBN directive, to continue funding your wallet with the virtual account below, kindly update your KYC. \n\nPlease note that you can also make use of other deposit options if you don't want to update your KYC yet.",
                                    fontSize: 13,
                                    align: TextAlign.center,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  RoundedButton(
                                    text: "Verify Account",
                                    press: () {
                                      Get.to(
                                        KYC(manager: widget.manager),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 10.0,
                                top: 10.0,
                              ),
                              child: Center(
                                child: ListView(
                                  children: [
                                    Center(
                                      child: TextPoppins(
                                        text:
                                            "In line with a CBN directive to every Website/App in Nigeria, to continue using monnify virtual account, please update your KYC here \n\nPlease note that you can also make use of other means of wallet funding if you don't want to update your KYC yet.",
                                        fontSize: 13,
                                        align: TextAlign.left,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(
                                            KYC(manager: widget.manager),
                                            transition: Transition.cupertino,
                                          );
                                        },
                                        child: TextPoppins(
                                          text: "Update Now",
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(1.0),
                                      itemBuilder: (context, index) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 24.0,
                                          ),
                                          TextPoppins(
                                            text: "Bank",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text:
                                                      "${widget.manager.getUser()['accounts'][index]['bank_name']}",
                                                ),
                                              );
                                              Constants.toast(
                                                  "Bank name copied to clipboard");
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextPoppins(
                                                  text:
                                                      "${widget.manager.getUser()['accounts'][index]['bank_name'] ?? ""}",
                                                  fontSize: 16,
                                                ),
                                                const Icon(Icons.copy)
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              backgroundColor:
                                                  Constants.accentColor,
                                              foregroundColor: Colors.grey,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16.0,
                                          ),
                                          TextPoppins(
                                            text: "Account Number",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text:
                                                      "${widget.manager.getUser()['accounts'][index]['account_number']}",
                                                ),
                                              );
                                              Constants.toast(
                                                  "Account number copied to clipboard");
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextPoppins(
                                                  text:
                                                      "${widget.manager.getUser()['accounts'][index]['account_number']}",
                                                  fontSize: 16,
                                                ),
                                                const Icon(Icons.copy)
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              backgroundColor:
                                                  Constants.accentColor,
                                              foregroundColor: Colors.grey,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16.0,
                                          ),
                                          TextPoppins(
                                            text: "Account Name",
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text:
                                                      "${widget.manager.getUser()['accounts'][index]['account_name']}",
                                                ),
                                              );
                                              Constants.toast(
                                                  "Account name copied to clipboard");
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextPoppins(
                                                  text:
                                                      "${widget.manager.getUser()['accounts'][index]['account_name']}",
                                                  fontSize: 16,
                                                ),
                                                const Icon(Icons.copy)
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0)),
                                              backgroundColor:
                                                  Constants.accentColor,
                                              foregroundColor: Colors.grey,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      itemCount: _controller.userData
                                              .value['accounts']?.length ??
                                          0,
                                      separatorBuilder: (context, index) =>
                                          const Column(
                                        children: [
                                          SizedBox(
                                            height: 24.0,
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 56.0),
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
              (widget.manager.getUser()['accounts'] ?? []).isEmpty
                  ? const SizedBox()
                  : Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 21.0),
                      child: RoundedButton(
                        text: "Share",
                        press: () {
                          Share.share('${_share()}',
                              subject: 'Airtimeslot Bank Detail');
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _share() {
    String result = "";
    for (var i = 0; i < widget.manager.getUser()['accounts'].length; i++) {
      result = widget.manager.getUser()['accounts'][i]['account_name'] +
          "\n" +
          widget.manager.getUser()['accounts'][i]['account_number'] +
          "\n" +
          widget.manager.getUser()['accounts'][i]['bank_name'] +
          "\n\n\n";
    }
    return result;
  }

  _generateAccount() async {
    _controller.setLoading(true);
    try {
      final _response = await APIService().generateVirtualAccount(
        widget.manager.getAccessToken(),
      );
      _controller.setLoading(false);

      if (_response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(_response.body);

        _controller.onInit();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: map['message'],
              ),
            );
          },
        );
      } else {
        Map<String, dynamic> map = jsonDecode(_response.body);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: map['message'],
              ),
            );
          },
        );
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }
}
