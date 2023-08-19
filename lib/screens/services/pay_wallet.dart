import 'dart:convert';

import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/preferences/preference_manager.dart';
import '../../helper/service/api_service.dart';
import '../../helper/state/state_controller.dart';

class PayWallet extends StatefulWidget {
  final PreferenceManager manager;
  final String transRef;
  const PayWallet({
    Key? key,
    required this.manager,
    required this.transRef,
  }) : super(key: key);

  @override
  State<PayWallet> createState() => _PayWalletState();
}

class _PayWalletState extends State<PayWallet> {
  final _otpController = OtpFieldController();
  final _controller = Get.find<StateController>();

  _loginWallet() async {
    _controller.setLoading(true);
    Map _payload = {
      "method": "wallet",
      "transaction_ref": widget.transRef,
      "wallet_pin": _otpController.toString()
    };
    try {
      final resp =
          await APIService().payment(_payload, widget.manager.getAccessToken());
      debugPrint("WALLET PAYMENT RESP>> ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(resp.body);
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        Constants.toast(errorMap['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }

  _resetPIN() async {
    _controller.setLoading(true);
    final _prefs = await SharedPreferences.getInstance();
    final _token = _prefs.getString("accessToken");

    try {
      final resp = await APIService().resetWalletPIN(_token);
      debugPrint("RESET WALLET PIN REPONSE>> ${resp.body}");
      _controller.setLoading(false);

      if (resp.statusCode == 200) {
        //Now use token sent to perform next request

      } else {
        Map<String, dynamic> _errorMap = jsonDecode(resp.body);
        Constants.toast(_errorMap['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextPoppins(
              text: "Pay With Wallet",
              fontSize: 18,
              color: Constants.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextRoboto(
              text: "Wallet Balance",
              fontSize: 14,
              align: TextAlign.center,
            ),
            Text(
              "${Constants.nairaSign(context).currencySymbol}${widget.manager.getUser()['wallet_balance']}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Constants.primaryColor,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextRoboto(
              text:
                  "Enter your wallet PIN to proceed. You are advised not disclose your PIN to anybody for security reasons.",
              fontSize: 14,
              align: TextAlign.center,
            ),
            const SizedBox(
              height: 10.0,
            ),
            OTPTextField(
              length: 4,
              width: MediaQuery.of(context).size.width * 0.75,
              fieldWidth: 48,
              contentPadding: const EdgeInsets.all(8.0),
              style: const TextStyle(
                fontSize: 17,
                color: Constants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              controller: _otpController,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              onCompleted: (pin) {
                if (kDebugMode) {
                  debugPrint("Completed: " + pin);
                }
              },
              spaceBetween: 4.0,
              keyboardType: TextInputType.number,
              obscureText: true,
              outlineBorderRadius: 1.5,
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundedButton(
              text: "Continue",
              color: Colors.green,
              press: () => _loginWallet(),
            ),
            const SizedBox(
              height: 8.0,
            ),
            // const TextDivider(text: "Forgot PIN?"),
            const SizedBox(
              height: 16.0,
            ),
            // RoundedButton(
            //   text: "Reset PIN",
            //   press: () => _resetPIN(),
            // ),
          ],
        ),
      ),
    );
  }
}
