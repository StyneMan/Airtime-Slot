import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BankTransfer extends StatelessWidget {
  final PreferenceManager manager;
  BankTransfer({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.accentColor,
      body: Column(
        children: [
          const SizedBox(height: 48),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: TextPoppins(
                  text: "Bank Transfer",
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
              elevation: 0.0,
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
                child: ListView(
                  children: [
                    Center(
                      child: TextPoppins(
                        text:
                            "Use the details below to send money to your AirtimeSlot wallet from any bank's app or through internet banking.",
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(1.0),
                      itemBuilder: (context, index) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                      "${manager.getUser()['accounts'][index]['bank_name']}",
                                ),
                              );
                              Constants.toast("Bank name copied to clipboard");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text:
                                      "${manager.getUser()['accounts'][index]['bank_name']}",
                                  fontSize: 16,
                                ),
                                const Icon(Icons.copy)
                              ],
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              backgroundColor: Constants.accentColor,
                              foregroundColor: Colors.grey,
                              padding: const EdgeInsets.all(16.0),
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
                                      "${manager.getUser()['accounts'][index]['account_number']}",
                                ),
                              );
                              Constants.toast(
                                  "Account number copied to clipboard");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text:
                                      "${manager.getUser()['accounts'][index]['account_number']}",
                                  fontSize: 16,
                                ),
                                const Icon(Icons.copy)
                              ],
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              backgroundColor: Constants.accentColor,
                              foregroundColor: Colors.grey,
                              padding: const EdgeInsets.all(16.0),
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
                                      "${manager.getUser()['accounts'][index]['account_name']}",
                                ),
                              );
                              Constants.toast(
                                  "Account name copied to clipboard");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextPoppins(
                                  text:
                                      "${manager.getUser()['accounts'][index]['account_name']}",
                                  fontSize: 16,
                                ),
                                const Icon(Icons.copy)
                              ],
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              backgroundColor: Constants.accentColor,
                              foregroundColor: Colors.grey,
                              padding: const EdgeInsets.all(16.0),
                            ),
                          ),
                        ],
                      ),
                      itemCount: _controller.userData.value['accounts'].length,
                      separatorBuilder: (context, index) => Column(
                        children: const [
                          SizedBox(
                            height: 24.0,
                          ),
                          Divider(),
                          SizedBox(
                            height: 12.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 21.0),
            child: RoundedButton(
              text: "Share",
              press: () {
                Share.share('${_share()}', subject: 'AirtimeSlot Bank Detail');
              },
            ),
          ),
        ],
      ),
    );
  }

  _share() {
    String result = "";
    for (var i = 0; i < manager.getUser()['accounts'].length; i++) {
      result = manager.getUser()['accounts'][i]['account_name'] +
          "\n" +
          manager.getUser()['accounts'][i]['account_number'] +
          "\n" +
          manager.getUser()['accounts'][i]['bank_name'] +
          "\n\n\n" ;
    }
    return result;
  }
}
