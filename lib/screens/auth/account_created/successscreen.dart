import 'dart:math';

import 'package:airtimeslot_app/components/dashboard/dashboard.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AccountSuccess extends StatefulWidget {
  const AccountSuccess({Key? key}) : super(key: key);

  @override
  State<AccountSuccess> createState() => _AccountSuccessState();
}

class _AccountSuccessState extends State<AccountSuccess> {
  // late ConfettiController _controllerTopCenter;
  // late ConfettiController _controllerCenterLeft;
  // late ConfettiController _controllerBottomCenter;

  PreferenceManager? _manager;

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
    // _controllerCenter =
    //     ConfettiController(duration: const Duration(seconds: 10));
    // _controllerCenterRight =
    //     ConfettiController(duration: const Duration(seconds: 10));
    // _controllerCenterLeft =
    //     ConfettiController(duration: const Duration(seconds: 45));
    // _controllerTopCenter =
    //     ConfettiController(duration: const Duration(seconds: 45));
    // _controllerBottomCenter =
    //     ConfettiController(duration: const Duration(seconds: 45));

    // // Future.delayed(const Duration(seconds: 1), () {
    // _controllerTopCenter.play();
    // _controllerCenterLeft.play();
    // _controllerBottomCenter.play();
    // });
  }

  @override
  void dispose() {
    // _controllerCenter.dispose();
    // _controllerCenterRight.dispose();
    // _controllerCenterLeft.dispose();
    // _controllerTopCenter.dispose();
    // _controllerBottomCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 1), () {
    //   _controllerTopCenter.play();
    //   _controllerCenterLeft.play();
    //   _controllerBottomCenter.play();
    // });

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: ConfettiWidget(
            //     confettiController: _controllerCenterLeft,
            //     blastDirection: 0, // radial value - RIGHT
            //     emissionFrequency: 0.6,
            //     minimumSize: const Size(10,
            //         10), // set the minimum potential size for the confetti (width, height)
            //     maximumSize: const Size(50,
            //         50), // set the maximum potential size for the confetti (width, height)
            //     numberOfParticles: 1,
            //     gravity: 0.1,
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: ConfettiWidget(
            //     confettiController: _controllerTopCenter,
            //     blastDirection: pi / 2,
            //     maxBlastForce: 5, // set a lower max blast force
            //     minBlastForce: 2, // set a lower min blast force
            //     emissionFrequency: 0.05,
            //     numberOfParticles: 50, // a lot of particles at once
            //     gravity: 1,
            //   ),
            // ),
            // //BOTTOM CENTER
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: ConfettiWidget(
            //     confettiController: _controllerBottomCenter,
            //     blastDirection: -pi / 2,
            //     emissionFrequency: 0.01,
            //     numberOfParticles: 60,
            //     maxBlastForce: 100,
            //     minBlastForce: 80,
            //     gravity: 0.3,
            //   ),
            // ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    size: 72,
                    color: Colors.green,
                  ),
                  TextPoppins(
                    text:
                        "Your account has been created, ${"John Doe".split(' ')[0]}.",
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    align: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.80,
                  //   child: TextPoppins(
                  //     text:
                  //         "You’re a few clicks away to staying on track with your nutrition goals",
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w500,
                  //     align: TextAlign.center,
                  //   ),
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: 18,
              left: 18,
              right: 18,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                      type: PageTransitionType.size,
                      alignment: Alignment.bottomCenter,
                      child: Dashboard(manager: _manager!),
                    ),
                  );
                },
                child: TextPoppins(
                  text: "Continue to Wallet",
                  fontSize: 14,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(14.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
