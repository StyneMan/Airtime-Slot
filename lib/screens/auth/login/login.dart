import 'dart:io';

import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/forms/login/loginform.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/auth/register/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:page_transition/page_transition.dart';

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
                          color: Constants.primaryColor,
                          child: Image.asset(
                            "assets/images/logo_big.png",
                            width: 56,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
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
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(21.0),
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
                      const SizedBox(
                        height: 48,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    "New to Airtimeslot? ",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                   SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "Sign Up ",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
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

                // Expanded(
                //   child: Stack(
                //     children: [
                //       const SizedBox(),
                //       Positioned(
                //         top: 18,
                //         right: -4,
                //         bottom: -5,
                //         child: Image.asset(
                //           "assets/images/login_img2.png",
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //       Positioned(
                //         top: 40,
                //         left: 8.0,
                //         child: IconButton(
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //           icon: const Icon(
                //             CupertinoIcons.arrow_left_circle_fill,
                //             color: Colors.black,
                //             size: 36,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Expanded(
                //   child: ListView(
                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //     shrinkWrap: true,
                //     children: [
                //       TextPoppins(
                //         text: "Welcome back!",
                //         fontSize: 24,
                //         color: Colors.black,
                //         fontWeight: FontWeight.bold,
                //       ),
                //       TextPoppins(
                //         text: "Sign in to your account!",
                //         fontSize: 14,
                //       ),
                //       const SizedBox(
                //         height: 14.0,
                //       ),
                //       LoginForm(
                //         manager: _manager!,
                //       ),
                //       const SizedBox(
                //         height: 14.0,
                //       ),
                //       Center(
                //         child: RichText(
                //           textAlign: TextAlign.center,
                //           text: TextSpan(
                //             text: "Don't have an account? ",
                //             style: const TextStyle(
                //               color: Colors.black,
                //             ),
                //             children: [
                //               TextSpan(
                //                 text: "Sign up ",
                //                 style: const TextStyle(
                //                   color: Constants.primaryColor,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //                 recognizer: TapGestureRecognizer()
                //                   ..onTap = () => Navigator.of(context).push(
                //                         PageTransition(
                //                           type: PageTransitionType.size,
                //                           alignment: Alignment.bottomCenter,
                //                           child: const Register(),
                //                         ),
                //                       ),
                //                 // ..onTap = _showTermsOfService,
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
