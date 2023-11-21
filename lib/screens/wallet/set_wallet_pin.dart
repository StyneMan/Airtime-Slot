import 'dart:convert';

import 'package:data_extra_app/components/dashboard/dashboard.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/model/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
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
  int _pin = 0;

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
        _controller.setUserData('${map['data']}');

        //Navigate to Dashboard from here
        // await APIService().fetchTransactions(_token);

        Constants.toast(map['message']);

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
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          backgroundColor: Constants.accentColor,
          body: Column(
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: Card(
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36.0),
                      topRight: Radius.circular(36.0),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  "assets/images/otp_lock_icon.svg",
                                  width: 48,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              const Center(
                                child: Text(
                                  "Set a pin code for your wallet.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 21.0),
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
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldWidth: 45,
                                fieldStyle: FieldStyle.box,
                                outlineBorderRadius: 15,
                                obscureText: true,
                                otpFieldStyle: OtpFieldStyle(
                                  backgroundColor: Constants.accentColor,
                                ),
                                style: const TextStyle(fontSize: 17),
                                onChanged: (pin) {
                                  debugPrint("Changed: " + pin);
                                  setState(() {
                                    _pin = int.parse(pin);
                                  });
                                },
                                onCompleted: (pin) {
                                  debugPrint("Completed: " + pin);
                                  // _verifyAccount(pin);
                                },
                              ),
                              const SizedBox(height: 64.0),
                              ElevatedButton(
                                child: TextPoppins(
                                  text: "SET WALLET PIN",
                                  fontSize: 15,
                                ),
                                onPressed: () {
                                  print("JKD ${_pin}");
                                  // if (_formKey.currentState!.validate()) {
                                  _setPIN(_pin);
                                  // }
                                },
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
