
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/screens/wallet/components/bank_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Withdraw extends StatefulWidget {
  final PreferenceManager manager;
  const Withdraw({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
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
                  text: "Withdraw funds",
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: TextPoppins(
                        text: "Select payment method",
                        fontSize: 21,
                        align: TextAlign.center,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(
                                WithdrawToBnnk(),
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
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/images/bank_deposit_icon.svg",
                                            color: Colors.white,
                                            width: 24,
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
                                        TextPoppins(
                                          text: "Bank account",
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        TextPoppins(
                                          text: "Send money to bank account",
                                          fontSize: 13,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Constants.toast("Coming soon!");
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
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/images/verify_icon.svg",
                                            color: Colors.white,
                                            width: 24,
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
                                        TextPoppins(
                                          text: "Airtime slot tag",
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        TextPoppins(
                                          text: "Coming soon",
                                          fontSize: 13,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
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
}
