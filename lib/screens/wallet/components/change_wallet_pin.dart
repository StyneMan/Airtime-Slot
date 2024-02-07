import 'dart:convert';

import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_password_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeWalletPIN extends StatefulWidget {
  const ChangeWalletPIN({Key? key}) : super(key: key);

  @override
  State<ChangeWalletPIN> createState() => _ChangeWalletPINState();
}

class _ChangeWalletPINState extends State<ChangeWalletPIN> {
  final _controller = Get.find<StateController>();

  final _formKey = GlobalKey<FormState>();

  final _currPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmNewPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 5.0,
          ),
          TextRoboto(
            text: "Current PIN",
            color: Constants.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          RoundedPasswordField(
            isPin: true,
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please type current wallet pin';
              }
              if (value.length < 4) {
                return 'Too short! Minimum of 4 characters.';
              }
              return null;
            },
            controller: _currPassController,
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextRoboto(
            text: "New PIN",
            color: Constants.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          RoundedPasswordField(
            isPin: true,
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please type new wallet PIN';
              }
              if (value.length < 4) {
                return 'Too short! Minimum of 4 characters.';
              }
              return null;
            },
            controller: _newPassController,
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextRoboto(
            text: "Confirm PIN",
            color: Constants.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          RoundedPasswordField(
            isPin: true,
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm new wallet PIN';
              }
              if (value.length < 4) {
                return 'Too short! Minimum of 4 characters.';
              } else if (value != _newPassController.text) {
                return 'Wallet PIN mismatch!';
              }
              return null;
            },
            controller: _confirmNewPassController,
          ),
          const SizedBox(
            height: 8.0,
          ),
          RoundedButton(
            text: "Update Wallet PIN",
            press: () {
              if (_formKey.currentState!.validate()) {
                _updatePIN();
              }
            },
          ),
        ],
      ),
    );
  }

  _updatePIN() async {
    _controller.setLoading(true);
    final _prefs = await SharedPreferences.getInstance();
    final _token = _prefs.getString("accessToken");

    Map _payload = {
      "old_wallet_pin": _currPassController.text,
      "wallet_pin": _newPassController.text,
      "wallet_pin_confirmation": _confirmNewPassController.text,
    };

    try {
      final resp = await APIService().changeWalletPIN(_payload, _token);
      debugPrint("CHANGE PIN >> >> ${resp.body}");
      _controller.setLoading(false);

      if (resp.statusCode == 200) {
        Constants.toast("Operation successful");
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        Constants.toast(errorMap['message'] ?? "Error occurred");
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }
}
