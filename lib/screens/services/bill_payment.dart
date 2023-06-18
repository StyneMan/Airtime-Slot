import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/screens/services/electricity/electricity.dart';
import 'package:airtimeslot_app/screens/services/television/television.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BillPayment extends StatelessWidget {
  const BillPayment({Key? key}) : super(key: key);

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
                  text: "Bill Payment",
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
                                const Electricity(),
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
                                            "assets/images/lamp_icon.svg",
                                            color: Colors.white,
                                            width: 16,
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
                                          text: "Electricity",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                            height: 10.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(
                                const Television(),
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
                                            "assets/images/television_icon.svg",
                                            color: Colors.white,
                                            width: 16,
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
                                          text: "Cable TV",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
