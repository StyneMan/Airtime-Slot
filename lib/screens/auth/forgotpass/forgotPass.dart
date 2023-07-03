import 'dart:convert';
import 'dart:io';

import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  _forgotPass() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    Map _payload = {
      "email": _emailController.text,
    };

    try {
      final response = await APIService().forgotPass(_payload);
      debugPrint("PASSWORD RESET :: ${response.body}");
      _controller.setLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constants.toast("${map['message']}");
        Navigator.pop(context);
      } else {
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        Constants.toast("${errorMap['message']}");
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
        backgroundColor: Colors.black54,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        child: Scaffold(
          backgroundColor: Constants.accentColor,
          body: Column(
            children: [
              const SizedBox(height: 48),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: TextPoppins(
                      text: "Forgot password",
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
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextPoppins(
                                text:
                                    "A password reset link will be sent to your email address.",
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: RoundedInputField(
                                  hintText: "Email",
                                  icon: const Icon(CupertinoIcons.person),
                                  onChanged: (val) {},
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email address';
                                    }
                                    if (!RegExp(
                                            '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }

                                    return null;
                                  },
                                  inputType: TextInputType.emailAddress,
                                  controller: _emailController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 21.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                width: double.infinity,
                                child: RoundedButton(
                                  text: "Continue",
                                  press: () {
                                    if (_formKey.currentState!.validate()) {
                                      _forgotPass();
                                    }
                                  },
                                ),
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
