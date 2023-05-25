import 'dart:convert';

import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_password_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/auth/wallet_pin.dart';
import 'package:airtimeslot_app/model/error/error.dart';
import 'package:airtimeslot_app/model/user/user_model.dart';
import 'package:airtimeslot_app/screens/wallet/components/change_wallet_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security extends StatelessWidget {
  final PreferenceManager manager;
  Security({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmNewPassController =
      TextEditingController();

  _updatePassword() async {
    _controller.setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString("accessToken") ?? "";

    Map _payload = {
      "current_password": _currPassController.text,
      "password": _newPassController.text,
      "password_confirmation": _confirmNewPassController.text,
    };

    try {
      final response = await APIService().updatePassword(_payload, _token);
      debugPrint("PASS RESP:: ${response.body}");
      debugPrint("PASS RESQ:: $_payload");
      _controller.setLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        WalletPINResponse data = WalletPINResponse.fromJson(map);
        //Update shared preference
        UserModel? model = data.data;
        String userData = jsonEncode(model);
        manager.setUserData(userData);
        manager.setIsLoggedIn(true);
        _controller.setUserData('${data.data}');

        Constants.toast("${data.message}");
      } else {
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        ErrorResponse error = ErrorResponse.fromJson(errorMap);
        Constants.toast("${error.message}");
      }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.white,
        backgroundColor: Constants.primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: TextPoppins(
          text: "Security".toUpperCase(),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (!_scaffoldKey.currentState!.isEndDrawerOpen) {
                _scaffoldKey.currentState!.openEndDrawer();
              }
            },
            icon: SvgPicture.asset(
              'assets/images/menu_icon.svg',
              color: Colors.white,
            ),
          ),
        ],
      ),
      endDrawer: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: CustomDrawer(
          manager: manager,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(
              height: 16.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextRoboto(
                    text: "Current Password",
                    color: Constants.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  RoundedPasswordField(
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please type current password';
                      }
                      if (value.length < 8) {
                        return 'Too short! Minimum of 8 characters.';
                      }
                      return null;
                    },
                    controller: _currPassController,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextRoboto(
                    text: "New Password",
                    color: Constants.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  RoundedPasswordField(
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please type new password';
                      }
                      if (value.length < 8) {
                        return 'Too short! Minimum of 8 characters.';
                      }
                      return null;
                    },
                    controller: _newPassController,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextRoboto(
                    text: "Confirm Password",
                    color: Constants.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  RoundedPasswordField(
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm new password';
                      }
                      if (value.length < 8) {
                        return 'Too short! Minimum of 8 characters.';
                      } else if (value != _newPassController.text) {
                        return 'Password mismatch!';
                      }
                      return null;
                    },
                    controller: _confirmNewPassController,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Divider(
                    color: Constants.accentColor,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showBarModalBottomSheet(
                        expand: false,
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) => Container(
                          height: 460,
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              TextPoppins(
                                text: "Change Wallet PIN",
                                fontSize: 18,
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold,
                                align: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              const ChangeWalletPIN()
                            ],
                          ),
                        ),
                        topControl: ClipOval(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Image.asset(
                      "assets/images/lock_icon.png", color: Constants.primaryColor,
                      width: 36,
                      height: 36,
                    ),
                    label: TextRoboto(
                      text: "Change Wallet PIN",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Constants.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  RoundedButton(
                    text: "UPDATE PASSWORD",
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        _updatePassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
