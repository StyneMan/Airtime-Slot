import 'dart:convert';

import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_disabled.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/inputs/rounded_phone_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/auth/wallet_pin.dart';
import 'package:airtimeslot_app/model/error/error.dart';
import 'package:airtimeslot_app/model/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfo extends StatefulWidget {
  final PreferenceManager manager;
  const PersonalInfo({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.manager.getUser()['name'];
    _phoneController.text = widget.manager.getUser()['phone'] ?? "";
  }

  _updateProfile() async {
    _controller.setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString("accessToken") ?? "";

    Map _payload = {
      "name": _nameController.text,
      "phone": _phoneController.text
    };

    try {
      final response = await APIService().updateProfile(_payload, _token);
      debugPrint("UPDTE RESP:: ${response.body}");
      debugPrint("UPDTE RESQ:: $_payload");
      _controller.setLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        WalletPINResponse data = WalletPINResponse.fromJson(map);
        //Update shared preference
        UserModel? model = data.data;
        String userData = jsonEncode(model);
        widget.manager.setUserData(userData);
        widget.manager.setIsLoggedIn(true);
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
          text: "Personal Information".toUpperCase(),
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
          manager: widget.manager,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            const SizedBox(
              height: 21.0,
            ),
            RoundedInputDisabledField(
              value: "${widget.manager.getUser()['ref']}",
              hintText: "Account ID",
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundedInputDisabledField(
              value: "${widget.manager.getUser()['referral_code']}",
              suffix: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: "${widget.manager.getUser()['referral_code']}"));
                  Constants.toast("Referral code copied to clipboard!");
                },
                child: const Icon(Icons.copy, size: 21.0),
              ),
              hintText: 'Referral Code',
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundedInputDisabledField(
              value: widget.manager.getUser()['email'],
              hintText: "Email",
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Divider(
              thickness: 1.0,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  RoundedInputField(
                    hintText: "Name",
                    icon: Icons.person,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your fullname';
                      }
                      return null;
                    },
                    controller: _nameController,
                    inputType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  RoundedPhoneField(
                    hintText: "Phone",
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp('^(?:[+0]234)?[0-9]{10}').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      if (value.length < 10) {
                        return 'Phone number not valid';
                      }
                      return null;
                    },
                    inputType: TextInputType.phone,
                    controller: _phoneController,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: TextPoppins(text: "SAVE PROFILE", fontSize: 16),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                      ),
                    ),
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
