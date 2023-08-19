import 'dart:convert';

import 'package:airtimeslot_app/components/dashboard/dashboard.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/auth/login_model.dart';
import 'package:airtimeslot_app/model/error/error.dart';
import 'package:airtimeslot_app/model/error/validation_error.dart';
import 'package:airtimeslot_app/screens/account/verify_account.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

typedef InitCallback(bool params);

class SignupForm extends StatefulWidget {
  final PreferenceManager manager;
  const SignupForm({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referalController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _countryCode = "+234";
  bool _obscureText = true, _loading = false;

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();

  _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // _sendOTP(var token) async {
  //   try {
  //     final response = await APIService().resendOTP(token);
  //     debugPrint("FIRST OTP:RESPONSE:: ${response.body}");

  //     _controller.setLoading(false);

  //     if (response.statusCode == 200) {
  //       //Now navigate to next screen here
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => VerifyAccount(
  //             manager: widget.manager,
  //             token: '$token',
  //             email: _emailController.text,
  //           ),
  //         ),
  //       );
  //     } else {}
  //   } catch (e) {
  //     _controller.setLoading(false);
  //     Constants.toast("$e");
  //   }
  // }

  _signup() async {
    FocusManager.instance.primaryFocus?.unfocus();

    Map _payload = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "password": _passwordController.text,
      "password_confirmation": _passwordController.text,
    };

    _controller.setLoading(true);

    try {
      final response = await APIService().signup(_payload);
      debugPrint("REGISTER RESP:: ${response.body}");
      _controller.setLoading(false);

      if (response.statusCode == 200) {
        Map<String, dynamic> registerMap = jsonDecode(response.body);

        _controller.setAccessToken('${registerMap['data']['token']}');
        widget.manager.saveAccessToken('${registerMap['data']['token']}');
        _controller.setUserData(registerMap['data']['user']);
        widget.manager.setIsLoggedIn(true);

        _controller.onInit();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
              manager: widget.manager,
            ),
          ),
        );

      } else {
        //Error occurred on login
        _controller.setLoading(false);
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        Constants.toast("${errorMap['message']}");
      }
    } catch (e) {
      _controller.setLoading(false);
      Constants.toast("$e");
      debugPrint("ERR::: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: RoundedInputField(
              hintText: "Full name",
              isIconed: true,
              icon: const Icon(CupertinoIcons.person),
              onChanged: (val) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your fullname';
                }
                return null;
              },
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
              controller: _nameController,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Constants.accentColor,
                filled: true,
                prefixIcon: CountryCodePicker(
                  alignLeft: false,
                  onChanged: (val) {
                    setState(() {
                      _countryCode = val as String;
                    });
                  },
                  flagWidth: 24,
                  initialSelection: 'NG',
                  favorite: const ['+234', 'NG'],
                  showCountryOnly: false,
                  showFlag: false,
                  showOnlyCountryWhenClosed: false,
                ),
                hintText: 'Phone Number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your number';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: _phoneController,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: RoundedInputField(
              hintText: "Email",
              isIconed: true,
              icon: const Icon(CupertinoIcons.mail),
              onChanged: (val) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
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
          // const SizedBox(
          //   height: 12.0,
          // ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10.0),
          //   child: TextFormField(
          //     decoration: const InputDecoration(
          //       border: InputBorder.none,
          //       enabledBorder: InputBorder.none,
          //       focusedBorder: InputBorder.none,
          //       filled: true,
          //       fillColor: Constants.accentColor,
          //       hintText: 'Referral',
          //     ),
          //     controller: _referalController,
          //     keyboardType: TextInputType.text,
          //   ),
          // ),
          const SizedBox(
            height: 12.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: true,
                fillColor: Constants.accentColor,
                hintText: 'Password',
                prefixIcon: const Icon(CupertinoIcons.lock),
                suffixIcon: IconButton(
                  onPressed: () => _togglePass(),
                  icon: Icon(
                    _obscureText
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please type password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              obscureText: _obscureText,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          const SizedBox(
            height: 36.0,
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _signup();
                }
              },
              child: TextPoppins(
                text: "Create account",
                fontSize: 14,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Constants.primaryColor,
                elevation: 0.2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
