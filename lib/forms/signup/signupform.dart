import 'dart:convert';

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

  _sendOTP(var token) async {
    try {
      final response = await APIService().resendOTP(token);
      debugPrint("FIRST OTP:RESPONSE:: ${response.body}");

      _controller.setLoading(false);

      if (response.statusCode == 200) {
        //Now navigate to next screen here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyAccount(
              manager: widget.manager,
              token: '$token',
              email: _emailController.text,
            ),
          ),
        );
      } else {
      }
    } catch (e) {
      _controller.setLoading(false);
      Constants.toast("$e");
    }
  }

  _signup() async {
    Map _payload = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "password": _passwordController.text,
      "referal_code": _referalController.text,
      "password_confirmation": _passwordController.text,
    };
    _controller.setLoading(true);

    try {
      final response = await APIService().signup(_payload);
      debugPrint("REGISTER RESP:: ${response.body}");
      _controller.setLoading(false);

      if (response.statusCode == 200) {
        Map<String, dynamic> registerMap = jsonDecode(response.body);
        LoginModel login = LoginModel.fromJson(registerMap);

        debugPrint("CHECKING::: ${login.data?.token}");

        _controller.setAccessToken('${login.data?.token}');
        widget.manager.saveAccessToken('${login.data?.token}');
        _controller.setUserData('${login.data?.user}');

        //Verify account from here...
        //Send verification email first
        _sendOTP("${login.data?.token}");
      } else if (response.statusCode == 422) {
        _controller.setLoading(false);
        //Error occurred on login
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        ValidationError error = ValidationError.fromJson(errorMap);
        Constants.toast("${error.errors?.email[0] ?? error.message}");
      } else {
        //Error occurred on login
        _controller.setLoading(false);
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        ErrorResponse error = ErrorResponse.fromJson(errorMap);
        Constants.toast("${error.message}");
      }
    } catch (e) {
      _controller.setLoading(false);
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
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              filled: false,
              labelText: 'Full Name',
              hintText: 'Full Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your fullname';
              }
              return null;
            },
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            controller: _nameController,
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              filled: false,
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
              labelText: 'Phone Number',
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
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 2.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              filled: false,
              labelText: 'Email',
              hintText: 'Email',
            ),
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
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 2.0,
              ),
              enabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              filled: false,
              labelText: 'Referral',
              hintText: 'Referral',
              
            ),
            controller: _referalController,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 2.0,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              filled: false,
              labelText: 'Password',
              hintText: 'Password',
              suffixIcon: IconButton(
                onPressed: () => _togglePass(),
                icon: Icon(
                  _obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please type password';
              }
              return null;
            },
            obscureText: _obscureText,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 13.0,
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
                foregroundColor: Colors.white, backgroundColor: Constants.primaryColor,
                elevation: 0.2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
