import 'dart:convert';

import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/inputs/rounded_input_field.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassForm extends StatelessWidget {
  ForgotPassForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _emailController = TextEditingController();

  _forgotPass() async {
    _controller.isLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();

    Map _payload = {
      "email": _emailController.text,
    };

    try {
      final response = await APIService().forgotPass(_payload);
      // debugPrint("PASSWORD RESET :: ${response.body}");
      _controller.setLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constants.toast("${map['message']}");
        Get.back();
        // Navigator.pop(context);
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
    return Column(
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
                    if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
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
    );
  }
}
