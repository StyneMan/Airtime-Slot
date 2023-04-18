import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../components/text_components.dart';
import '../../../helper/constants/constants.dart';
import '../../../helper/preference/preference_manager.dart';
import '../../../helper/state/state_manager.dart';
import '../account_created/successscreen.dart';
import '../resetpass/resetpass.dart';

typedef void InitCallback(params);

class VerifyOTP extends StatefulWidget {
  final String caller;
  var credential;
  InitCallback? onEntered;
  String? email, pass, phone, name, verificationId;
  VerifyOTP({
    Key? key,
    required this.caller,
    this.verificationId,
    this.onEntered,
    this.credential,
    this.email,
    this.name,
    this.pass,
    this.phone,
  }) : super(key: key);

  @override
  State<VerifyOTP> createState() => _State();
}

class _State extends State<VerifyOTP> {
  final _controller = Get.find<StateController>();
  final _otpController = TextEditingController();
  PreferenceManager? _manager;
  String _code = '';
  CountdownTimerController? _timerController;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 5;

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
  }

  _resendCode() async {
    // _controller.setLoading(true);
    // try {
    //   FirebaseAuth _auth = FirebaseAuth.instance;
    //   await _auth.verifyPhoneNumber(
    //     phoneNumber: "${widget.phone}",
    //     verificationCompleted: (PhoneAuthCredential credential) {
    //       _controller.setLoading(false);
    //       // resp.user!.updatePhoneNumber(credential);
    //     },
    //     verificationFailed: (FirebaseAuthException e) {
    //       _controller.setLoading(false);
    //       if (e.code == 'invalid-phone-number') {
    //         print('The provided phone number is not valid.');
    //         Constants.toast('The provided phone number is not valid.');
    //       } else if (e.code == "expired-action-code") {
    //         Constants.toast('The code has expired. Try again.');
    //       } else if (e.code == "invalid-action-code") {
    //         Constants.toast('Incorrect code entered.');
    //       } else {
    //         print("${e.code} - ${e.message}");
    //         Constants.toast('${e.message}');
    //       }
    //     },
    //     codeSent: (String verificationId, int? resendToken) {
    //       _controller.setLoading(false);
    //       //show dialog to take input from the user
    //     },
    //     codeAutoRetrievalTimeout: (String verificationId) {
    //       _controller.setLoading(false);
    //     },
    //   );

    //   _controller.setLoading(false);
    // } catch (e) {
    //   _controller.setLoading(false);
    // }
  }

  _linkAccount() async {
    //
  }

  @override
  void dispose() {
    super.dispose();
    _timerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value, // _controller.isLoading.value,
        backgroundColor: Colors.black54,
        progressIndicator: Platform.isAndroid
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const CupertinoActivityIndicator(
                animating: true,
              ),
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Center(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10.0,
                    ),
                    children: [
                      Image.asset(
                        "assets/images/otp_verification_img.png",
                        width: MediaQuery.of(context).size.width * 0.14,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextPoppins(
                        text: "OTP Verification",
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      TextPoppins(
                        text:
                            "Please type the 6 digit OTP code sent to ${widget.phone}.",
                        fontSize: 14,
                        align: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
                        autoFocus: true,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v!.length < 3) {
                            return "I'm from validator";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderWidth: 0.75,
                          fieldOuterPadding:
                              const EdgeInsets.symmetric(horizontal: 0.0),
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        // enableActiveFill: true,
                        // errorAnimationController: errorController,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        onChanged: (value) {
                          debugPrint(value);
                        },
                        beforeTextPaste: (text) {
                          debugPrint("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CountdownTimer(
                        controller: _timerController,
                        endTime: endTime,
                        widgetBuilder: (_, CurrentRemainingTime? time) {
                          if (time == null) {
                            return TextButton(
                              onPressed: () {
                                _timerController?.start();
                                _resendCode();
                              },
                              child: TextPoppins(
                                text: 'Resend OTP',
                                fontSize: 18,
                                align: TextAlign.center,
                                fontWeight: FontWeight.w500,
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(12.0),
                              ),
                            );
                          }
                          return TextPoppins(
                            text:
                                'Resend code in ${time.min ?? "0"} : ${time.sec}',
                            fontSize: 15,
                            align: TextAlign.center,
                            color: Constants.primaryColor,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.caller == "Password") {
                            Navigator.of(context).push(
                              PageTransition(
                                type: PageTransitionType.size,
                                alignment: Alignment.bottomCenter,
                                child: const ResetPassword(),
                              ),
                            );
                          } else {
                            _linkAccount();
                          }
                        },
                        child: TextPoppins(
                          text: 'Verify OTP',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 8.0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_left_circle_fill,
                      color: Colors.black,
                      size: 36,
                    ),
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
