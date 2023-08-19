import 'dart:convert';

import 'package:airtimeslot_app/components/dashboard/dashboard.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/error/error.dart';
import 'package:airtimeslot_app/model/error/validation_error.dart';
import 'package:airtimeslot_app/screens/account/verify_account.dart';
import 'package:airtimeslot_app/screens/auth/forgotpass/forgotPass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  final PreferenceManager manager;
  LoginForm({Key? key, required this.manager}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();

  _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Map _payload = {
      "email": _emailController.text,
      "password": _passwordController.text
    };
    //Perform Login here
    _controller.setLoading(true);
    try {
      final response = await APIService().login(_payload);
      // debugPrint("LOGIN RESP:: ${response.body}");

      _controller.setLoading(false);

      if (response.statusCode == 200) {
        Map<String, dynamic> loginMap = jsonDecode(response.body);
        // LoginModel login = LoginModel.fromJson(loginMap);
        // debugPrint('TESTTERRE:::: ${loginMap['data']['token']}');

        _controller.setAccessToken('${loginMap['data']['token']}');
        widget.manager.saveAccessToken('${loginMap['data']['token']}');

        // final _toks = "${loginMap['data']['token']}";

        // UserModel? model = login.data?.user;

        // if (loginMap['data']['user']['is_account_verified']) {
          //Account has been verified. Now check if wallet pin is set.
          // if (loginMap['data']['user']['is_wallet_pin']) {
          //Wallet pin has been set, go to dashboard from here.
          //Save user data and preferences
          String userData = jsonEncode(loginMap['data']['user']);
          widget.manager.setUserData(userData);

          _controller.setUserData(loginMap['data']['user']);

          // await APIService().fetchTransactions(_toks);

          widget.manager.setIsLoggedIn(true);
          _controller.setLoading(false);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(manager: widget.manager),
            ),
          );
        // } else {
          //Verify account from here...
        //   _controller.setLoading(false);
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => VerifyAccount(
        //         manager: widget.manager,
        //         token: '${loginMap['data']['token']}',
        //         email: _emailController.text,
        //       ),
        //     ),
        //   );
        // }
      } else if (response.statusCode == 422) {
        
        //Error occurred on login
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        ValidationError error = ValidationError.fromJson(errorMap);
        Constants.toast("${error.errors?.email[0] ?? error.message}");
      } else {
        //Error occurred on login
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        ErrorResponse error = ErrorResponse.fromJson(errorMap);
        Constants.toast("${error.message}");
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint("ERR::: $e");
      Constants.toast("$e");
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
              hintText: "Email",
              height: 14.0,
              isIconed: true,
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
          const SizedBox(
            height: 16.0,
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
                return null;
              },
              obscureText: _obscureText,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextButton(
            onPressed: () {
              Get.to(
                ForgotPassword(),
                transition: Transition.cupertino,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Forgot email",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Constants.primaryColor,
                  ),
                ),
                TextPoppins(
                  text: " or ",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                const Text(
                  "Password?",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Constants.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32.0,
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
                  _login();
                }
              },
              child: TextPoppins(
                text: "Login",
                fontSize: 15,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Constants.primaryColor,
                elevation: 0.2,
              ),
            ),
          ),
          const SizedBox(
            height: 21.0,
          ),
        ],
      ),
    );
  }
}
