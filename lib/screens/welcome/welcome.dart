import 'package:airtimeslot_app/components/dashboard/dashboard.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/text_components.dart';
import '../auth/login/login.dart';
import '../auth/register/register.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  PreferenceManager? _manager;

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/welcome_bg.jpg",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              top: 8.0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(234, 0, 0, 0),
                      Color.fromARGB(90, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 56.0,
                  horizontal: 20.0,
                ),
                child: const SizedBox(
                  height: 48.0,
                ),
              ),
            ),
            Positioned(
              bottom: 56,
              left: 56,
              right: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.size,
                            alignment: Alignment.bottomCenter,
                            child: const Login(),
                          ),
                        );
                      },
                      child: const Text("Sign in"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white.withOpacity(0.38),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.size,
                            alignment: Alignment.bottomCenter,
                            child: const Register(),
                          ),
                        );
                      },
                      child: const Text(
                        "Create an account",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 21.0,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 56,
              left: 24,
              right: 24,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app_logo.png',
                      width: MediaQuery.of(context).size.width * 0.225,
                    ),
                    TextPoppins(
                      text: "Airtime Slot Services",
                      fontSize: 24,
                      color: Colors.white,
                      align: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextPoppins(
                      text: "You Are Welcome",
                      fontSize: 28,
                      color: Colors.white,
                      align: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    TextRoboto(
                      text: "Create account or continue as a guest.",
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
