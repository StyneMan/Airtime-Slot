import 'dart:convert';
import 'dart:io';

import 'package:data_extra_app/components/dialogs/info_dialog.dart';
import 'package:data_extra_app/components/drawer/custom_drawer.dart';
import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/inputs/rounded_password_field.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/model/auth/wallet_pin.dart';
import 'package:data_extra_app/model/error/error.dart';
import 'package:data_extra_app/model/user/user_model.dart';
import 'package:data_extra_app/screens/wallet/components/change_wallet_pin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security extends StatefulWidget {
  final PreferenceManager manager;
  Security({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final _formKey = GlobalKey<FormState>();

  final _controller = Get.find<StateController>();

  final _currPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmNewPassController = TextEditingController();

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _togglePass2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  _togglePass3() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }

  _updatePassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
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
        //Update shared preference
        String userData = jsonEncode(map['data']);
        widget.manager.setUserData(userData);
        _controller.setUserData(map['data']);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: "Password updated successfully",
              ),
            );
          },
        );

        _controller.onInit();
        Get.back();
      } else {
        Map<String, dynamic> errorMap = jsonDecode(response.body);
        ErrorResponse error = ErrorResponse.fromJson(errorMap);
        Constants.toast("${error.message}");
      }
    } on SocketException {
      _controller.hasInternetAccess.value = false;
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        backgroundColor: Colors.black54,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        child: Scaffold(
          backgroundColor: Constants.accentColor,
          body: Column(
            children: [
              const SizedBox(height: 48),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: TextPoppins(
                      text: "Change password",
                      fontSize: 21,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Positioned(
                    left: 8.0,
                    top: -5,
                    bottom: -5,
                    child: Center(
                      child: ClipOval(
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36.0),
              Expanded(
                child: Card(
                  color: Colors.white.withOpacity(.9),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36.0),
                      topRight: Radius.circular(36.0),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    filled: true,
                                    fillColor: Constants.accentColor,
                                    hintText: 'Current password',
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
                                      return 'Please type current password';
                                    }
                                    return null;
                                  },
                                  obscureText: _obscureText,
                                  controller: _currPassController,
                                  keyboardType: TextInputType.visiblePassword,
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
                                    hintText: 'New password',
                                    prefixIcon: const Icon(CupertinoIcons.lock),
                                    suffixIcon: IconButton(
                                      onPressed: () => _togglePass2(),
                                      icon: Icon(
                                        _obscureText2
                                            ? CupertinoIcons.eye_slash
                                            : CupertinoIcons.eye,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please type new password';
                                    }
                                    return null;
                                  },
                                  obscureText: _obscureText2,
                                  controller: _newPassController,
                                  keyboardType: TextInputType.visiblePassword,
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
                                    hintText: 'Confirm new password',
                                    prefixIcon: const Icon(CupertinoIcons.lock),
                                    suffixIcon: IconButton(
                                      onPressed: () => _togglePass3(),
                                      icon: Icon(
                                        _obscureText3
                                            ? CupertinoIcons.eye_slash
                                            : CupertinoIcons.eye,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please re-type new password';
                                    }
                                    if (value != _newPassController.text) {
                                      return 'Password mismatch. Check password and try again';
                                    }
                                    return null;
                                  },
                                  obscureText: _obscureText3,
                                  controller: _confirmNewPassController,
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                width: double.infinity,
                                child: RoundedButton(
                                  text: "Continue",
                                  press: () {
                                    if (_formKey.currentState!.validate()) {
                                      _updatePassword();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
