import 'dart:io';

import 'package:easyfit_app/components/text_components.dart';
import 'package:easyfit_app/forms/resetpassword/resetpassform.dart';
import 'package:easyfit_app/helper/constants/constants.dart';
import 'package:easyfit_app/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _State();
}

class _State extends State<ResetPassword> {
  bool _isLoading = false;
  // final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return
        // Obx(
        //   () =>
        LoadingOverlayPro(
      isLoading: _isLoading, // _controller.isLoading.value,
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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset("assets/images/reset_pass_img.png"),
                      const SizedBox(
                        height: 24.0,
                      ),
                      TextPoppins(
                        text: "Reset Password",
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      Container(
                        child: Wrap(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.64,
                              child: TextPoppins(
                                text:
                                    "Enter account new password and confirm the password.",
                                fontSize: 14,
                                align: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      ResetPasswordForm(),
                    ],
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
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
          ),
        ),
      ),
      // ),
    );
  }
}
