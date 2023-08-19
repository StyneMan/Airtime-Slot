import 'package:airtimeslot_app/components/dialogs/info_dialog.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Splasher extends StatelessWidget {
  const Splasher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(21.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo_white.png",
                  ),
                  TextPoppins(
                    text: "Airtimeslot",
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: TextPoppins(
                        text:
                            "The easiest way to buy Internet data, Airtime top-ups, cable TV subscriptions and Electricity.",
                        fontSize: 14,
                        align: TextAlign.center,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 21.0,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 12,
              right: 12,
              child: ElevatedButton(
                onPressed: () {
                 
                  Get.to(
                    const Welcome(),
                    transition: Transition.cupertino,
                  );
                },
                child: TextPoppins(
                  text: "Continue",
                  fontSize: 16,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.white,
                  foregroundColor: Constants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
