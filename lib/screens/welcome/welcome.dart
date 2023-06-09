import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/screens/auth/login/login.dart';
import 'package:airtimeslot_app/screens/auth/register/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../components/text_components.dart';

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
      backgroundColor: Constants.accentColor,
      body: Column(
        // clipBehavior: Clip.none,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Image.asset("assets/images/welcome.png"),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextPoppins(
                      text: "Airtimeslot Services",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      align: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      "The easiest way to make your online payments for Internet, Data, Airtime, Cable TV",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36.0),
                topRight: Radius.circular(36.0),
              ),
              child: Card(
                elevation: 2.0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedButton(
                        text: "Sign in",
                        press: () {
                          Get.to(Login(), transition: Transition.downToUp);
                        },
                        color: Constants.primaryColor,
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      RoundedButton(
                        text: "Create an account",
                        press: () {
                          Get.to(
                            const Register(),
                            transition: Transition.downToUp,
                          );
                        },
                        color: Constants.accentColor,
                        textColor: Constants.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 
}
