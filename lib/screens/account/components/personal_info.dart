import 'dart:convert';
import 'dart:io';

import 'package:data_extra_app/components/dialogs/info_dialog.dart';
import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/inputs/rounded_button_wrapped.dart';
import 'package:data_extra_app/components/inputs/rounded_input_disabled.dart';
import 'package:data_extra_app/components/inputs/rounded_input_field.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/model/error/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfo extends StatefulWidget {
  final PreferenceManager manager;
  final bool shouldEdit;
  const PersonalInfo({
    Key? key,
    this.shouldEdit = false,
    required this.manager,
  }) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();

  String _selectedGender = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.manager.getUser()['name'];
    _phoneController.text = widget.manager.getUser()['phone'] ?? "";
  }

  _updateProfile() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString("accessToken") ?? "";

    Map _payload = {
      "name": _nameController.text,
      "phone": _phoneController.text,
      "dob": _dateController.text,
      "gender": _selectedGender.toLowerCase()
    };

    try {
      final response = await APIService().updateProfile(_payload, _token);
      debugPrint("UPDTE RESP:: ${response.body}");
      debugPrint("UPDTE RESQ:: $_payload");
      _controller.setLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);

        String userData = jsonEncode(map['data']);
        widget.manager.setUserData(userData);
        _controller.setUserData(map['data']);

        // Constants.toast("Profile updated successfully");

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: "Profile updated successfully",
              ),
            );
          },
        );

        _controller.onInit();
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
                      text: "Personal information",
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
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  ClipOval(
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/images/personal_icon.svg",
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  widget.shouldEdit
                                      ? const SizedBox()
                                      : Center(
                                          child: RoundedButtonWrapped(
                                            text: "Edit",
                                            press: () {},
                                          ),
                                        )
                                ],
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputDisabledField(
                                  hintText: "Account Ref",
                                  suffix: const Icon(
                                      CupertinoIcons.check_mark_circled_solid,
                                      color: Colors.green),
                                  value: "${widget.manager.getUser()['ref']}",
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputField(
                                  labelText: "Name",
                                  validator: (val) {
                                    if (val.toString().isEmpty || val == null) {
                                      return "Name is required";
                                    }
                                    return null;
                                  },
                                  height: 10.0,
                                  controller: _nameController,
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                  onChanged: (value) {},
                                  hintText: "Enter your name",
                                ),
                              ),
                              // const SizedBox(
                              //   height: 16.0,
                              // ),
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(16.0),
                              //   child: RoundedDropdownGender(
                              //     items: const ["Male", "Female"],
                              //     validator: (val) {
                              //       if (val.toString().isEmpty || val == null) {
                              //         return "Gender is required";
                              //       }
                              //       return null;
                              //     },
                              //     onSelected: _onGenderSelected,
                              //     placeholder: "Select gender",
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 16.0,
                              // ),
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(16.0),
                              //   child: RoundedDatePicker(
                              //     hintText: "dd/mm/yyyy",
                              //     onSelected: _onDateSelected,
                              //     controller: _dateController,
                              //     validator: (val) {
                              //       if (val.toString().isEmpty || val == null) {
                              //         return "Date of birth is required";
                              //       }
                              //       return null;
                              //     },
                              //     height: 10.0,
                              //     labelText: "Date of Birth",
                              //   ),
                              // ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputField(
                                  labelText: "Phone number",
                                  validator: (val) {
                                    if (val.toString().isEmpty || val == null) {
                                      return "Phone number is required";
                                    }
                                    return null;
                                  },
                                  height: 10.0,
                                  controller: _phoneController,
                                  inputType: TextInputType.number,
                                  onChanged: (value) {},
                                  hintText:
                                      "${widget.manager.getUser()['phone']}",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 21.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                width: double.infinity,
                                child: RoundedButton(
                                  text: "Continue",
                                  press: () {
                                    if (_formKey.currentState!.validate()) {
                                      _updateProfile();
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
