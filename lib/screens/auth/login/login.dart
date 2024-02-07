import 'dart:io';

import 'package:airtimeslot_app/forms/login/loginform.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/auth/register/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  PreferenceManager? _manager;

  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
    // Future.delayed(const Duration(seconds: 3), () {
    //   // Get.offAll(const Login());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        backgroundColor: Colors.black54,
        progressIndicator: Platform.isAndroid
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const CupertinoActivityIndicator(
                animating: true,
              ),
        child: Scaffold(
          backgroundColor: Constants.accentColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 56.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          child: Image.asset(
                            "assets/images/ic_launcher.png",
                            width: 56,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Welcome back",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 21.0,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36.0),
                          side: const BorderSide(
                            color: Constants.primaryColor,
                            width: 0.25,
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(21.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFBBDCF7),
                                offset: Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 7.0,
                                spreadRadius: 2.0,
                              ), //BoxShadow
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 16.0,
                              ),
                              LoginForm(
                                manager: _manager!,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(
                                  const Register(),
                                  transition: Transition.downToUp,
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "New to AirtimeSlot? ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "Sign Up ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins",
                                    ),
                                  )
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(14.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Constants.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
