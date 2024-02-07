import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splasher extends StatefulWidget {
  const Splasher({Key? key}) : super(key: key);

  @override
  State<Splasher> createState() => _SplasherState();
}

class _SplasherState extends State<Splasher> {
  // final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
  }

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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Image.asset(
                      "assets/images/logo_white.png",
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
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
