import 'dart:convert';
import 'dart:io';

import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/auth/otp_resend.dart';
import 'package:airtimeslot_app/model/error/error.dart';
import 'package:airtimeslot_app/screens/auth/account_created/successscreen.dart';
import 'package:airtimeslot_app/screens/wallet/set_wallet_pin.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class VerifyAccount extends StatefulWidget {
  final PreferenceManager manager;
  final String token;
  final String email;
  const VerifyAccount({
    Key? key,
    required this.manager,
    required this.token,
    required this.email,
  }) : super(key: key);

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  OtpFieldController otpController = OtpFieldController();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  _resendOTP() async {
    _controller.setLoading(true);
    try {
      final response = await APIService().resendOTP(widget.token);
      _controller.setLoading(false);
      debugPrint("OTP:RESPONSE:: ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        var model = OTPResend.fromJson(map);
        Constants.toast("${model.data}");
      } else {}
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  _verifyAccount(otp) async {
    Map _payload = {
      "token": otp,
    };
    _controller.setLoading(true);
    try {
      final response = await APIService().verify(_payload, widget.token);
      _controller.setLoading(false);
      debugPrint("RESPONSE:: ${response.body}");

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SetWalletPin(manager: widget.manager,),
          ),
        );
      } else {
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        ErrorResponse error = ErrorResponse.fromJson(errorMap);
        Constants.toast("${error.message}");
      }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: Platform.isAndroid
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const CupertinoActivityIndicator(
                animating: true,
              ),
        backgroundColor: Colors.black54,
        child: Scaffold(
          backgroundColor: Constants.accentColor,
          body: Column(
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: Card(
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36.0),
                      topRight: Radius.circular(36.0),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Verify Account",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "An OTP code has been sent to your email (${widget.email}). \nCheck your email and enter code here.",
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 21.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              OTPTextField(
                                controller: otpController,
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldWidth: 45,
                                fieldStyle: FieldStyle.box,
                                outlineBorderRadius: 15,
                                obscureText: true,
                                otpFieldStyle: OtpFieldStyle(
                                  backgroundColor: Constants.accentColor,
                                ),
                                style: const TextStyle(fontSize: 17),
                                onChanged: (pin) {
                                  debugPrint("Changed: " + pin);
                                },
                                onCompleted: (pin) {
                                  debugPrint("Completed: " + pin);
                                  _verifyAccount(pin);
                                },
                              ),
                              const SizedBox(height: 21.0),
                              ElevatedButton(
                                child: TextPoppins(
                                    text: "RESEND CODE", fontSize: 15),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _resendOTP();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
