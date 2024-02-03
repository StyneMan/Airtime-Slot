import 'dart:convert';

import 'package:data_extra_app/components/dialogs/info_dialog.dart';
import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/inputs/rounded_date_picker.dart';
import 'package:data_extra_app/components/inputs/rounded_dropdown_gender.dart';
import 'package:data_extra_app/components/inputs/rounded_input_field.dart';
import 'package:data_extra_app/components/inputs/rounded_phone_field.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/model/error/error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class KYC extends StatefulWidget {
  final PreferenceManager manager;
  KYC({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<KYC> createState() => _KYCState();
}

class _KYCState extends State<KYC> {
  final _controller = Get.find<StateController>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bvnController = TextEditingController();
  final _ninController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();

  String? _gender = "";

  String? _dob;

  @override
  void initState() {
    super.initState();
    if (widget.manager.getUser()['has_kyc']) {
      setState(() {
        _nameController.text = "${widget.manager.getUser()['name'] ?? ""}";
        _bvnController.text = "${widget.manager.getUser()['bvn'] ?? ""}";
        _phoneController.text = "${widget.manager.getUser()['phone'] ?? ""}";
        _dateController.text = "${widget.manager.getUser()['dob'] ?? ""}";
        _gender = "${widget.manager.getUser()['gender'] ?? ""}";
      });
    }
  }

  void onSelected(String gender) {
    _gender = gender;
  }

  void onDateSelected(String date) {
    debugPrint("DATE SELECTED:: $date");
    _dateController.text = date;
    _dob = date;
  }

  _saveKYC() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // final prefs = await SharedPreferences.getInstance();
    // String _token = prefs.getString("accessToken") ?? "";

    Map _payload = {
      "bvn": _bvnController.text,
      "gender": "$_gender".toLowerCase(),
      "dob": _dob,
      "name": _nameController.text,
      "phone": _phoneController.text,
      "nin": _ninController.text
    };

    _controller.setLoading(true);

    try {
      final response = await APIService().kyc(_payload, "_token");
      debugPrint("KYC RESP:: ${response.body}");
      debugPrint("KYC RESQ:: $_payload");

      _controller.setLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        debugPrint("KYC MAP:: ${map}");
        Constants.toast("${map['message']}");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: "${map['message']}",
              ),
            );
          },
        );
        _controller.onInit();
        // WalletPINResponse data = WalletPINResponse.fromJson(map);
        //Update shared preference
        // UserModel? model = data.data;
        String userData = map['data'];
        // jsonEncode(model);
        widget.manager.setUserData(userData);
        // _controller.setUserData('${data.data}');
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
                      text: "KYC",
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListView(
                      children: [
                        TextPoppins(
                          text:
                              "Kindly fill the form below to complete your KYC process",
                          color: Colors.black54,
                          fontSize: 16,
                          align: TextAlign.center,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 21.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputField(
                                  hintText: "Full name",
                                  icon: const Icon(Icons.person),
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter your full name';
                                    }
                                    return null;
                                  },
                                  controller: _nameController,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedDropdownGender(
                                  placeholder: _gender.toString().capitalize ??
                                      "Select your gender",
                                  onSelected: onSelected,
                                  items: const ["Male", "Female"],
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedDatePicker(
                                  labelText: "Date of birth",
                                  hintText: _dob ?? "Date of birth",
                                  onSelected: onDateSelected,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter your date of birth';
                                    }
                                    return null;
                                  },
                                  controller: _dateController,
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputField(
                                  hintText: "NIN",
                                  icon: const Icon(Icons.person),
                                  onChanged: (value) {},
                                  isEnabled:
                                      widget.manager.getUser()['nin'] != null
                                          ? false
                                          : true,
                                  validator: (value) {
                                    if (widget.manager.getUser()['nin'] ==
                                        null) {
                                      if (_bvnController.text.isEmpty &&
                                          value.toString().isEmpty) {
                                        return 'Provide your NIN since BVN is empty';
                                      }
                                    }

                                    return null;
                                  },
                                  controller: _ninController,
                                  inputType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputField(
                                  hintText: "BVN",
                                  icon: const Icon(Icons.person),
                                  onChanged: (value) {},
                                  isEnabled:
                                      widget.manager.getUser()['bvn'] != null
                                          ? false
                                          : true,
                                  validator: (value) {
                                    if (widget.manager.getUser()['bvn'] ==
                                        null) {
                                      if (_ninController.text.isEmpty &&
                                          value.toString().isEmpty) {
                                        return 'Provide your BVN since NIN is empty';
                                      }

                                      if (value.length > 11) {
                                        return 'Enter a valid bvn';
                                      }
                                    }

                                    return null;
                                  },
                                  controller: _bvnController,
                                  inputType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedPhoneField(
                                  hintText: "BVN Phone",
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your bvn phone number';
                                    }
                                    if (!RegExp('^(?:[+0]234)?[0-9]{10}')
                                        .hasMatch(value)) {
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
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              TextPoppins(
                                text:
                                    "Note: Ensure the provided information matches the information supplied during your BVN registration",
                                color: Colors.black54,
                                fontSize: 13,
                                align: TextAlign.left,
                                fontWeight: FontWeight.w400,
                              ),
                              const SizedBox(
                                height: 32.0,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                width: double.infinity,
                                child: RoundedButton(
                                  text: "SAVE KYC",
                                  press: () {
                                    if (_formKey.currentState!.validate() &&
                                        "$_gender".isNotEmpty) {
                                      _saveKYC();
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
