import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import '../../../components/text_components.dart';
import '../../../forms/forgotPassword/passwordform.dart';
import '../../../helper/state/state_manager.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final _controller = Get.find<StateController>();

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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    const SizedBox(),
                    Positioned(
                      top: 18,
                      right: -4,
                      bottom: 10,
                      child: Image.asset(
                        "assets/images/forgot_logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 8.0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
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
              Expanded(
                flex: 2,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  shrinkWrap: true,
                  children: [
                    TextPoppins(
                      text: "Forgot Password",
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    TextPoppins(
                      text: "Enter the email associated with your account.",
                      fontSize: 14,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    PasswordForm(),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
