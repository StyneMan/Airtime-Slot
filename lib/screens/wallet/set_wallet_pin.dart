import 'dart:convert';

import 'package:airtimeslot_app/components/dashboard/dashboard.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetWalletPin extends StatefulWidget {
  final PreferenceManager manager;
  const SetWalletPin({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<SetWalletPin> createState() => _SetWalletPinState();
}

class _SetWalletPinState extends State<SetWalletPin> {
  OtpFieldController otpController = OtpFieldController();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  _setPIN(var pin) async {
    Map _payload = {
      "wallet_pin": pin,
      "wallet_pin_confirmation": pin,
    };
    _controller.setLoading(true);
    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      final resp = await APIService().setWalletPIN(
        _payload,
        widget.manager.getAccessToken(),
      );
      // debugPrint("${resp.body}");
      // debugPrint(resp.body.data);
      if (resp.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(resp.body);

        String userData = jsonEncode(map['data']);
        widget.manager.setUserData(userData);
        _controller.setUserData('${pin.data}');

        //Navigate to Dashboard from here
        await APIService().fetchTransactions(_token);

        widget.manager.setIsLoggedIn(true);
        _controller.setLoading(false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(manager: widget.manager),
          ),
        );
      } else {
        _controller.setLoading(false);
      }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 56),
            Image.asset(
              "assets/images/app_logo.png",
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: TextPoppins(
                  text: "Set Wallet PIN",
                  fontSize: 21,
                  color: Constants.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OTPTextField(
                    controller: otpController,
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 45,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 15,
                    style: const TextStyle(fontSize: 17),
                    onChanged: (pin) {
                      debugPrint("Changed: " + pin);
                    },
                    onCompleted: (pin) {
                      debugPrint("Completed: " + pin);
                      _setPIN(pin);
                    },
                  ),
                  const SizedBox(height: 21.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
