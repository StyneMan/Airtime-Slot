import 'dart:convert';

import 'package:airtimeslot_app/components/dialogs/info_dialog.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_dropdown_gender.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/error/error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MBT extends StatefulWidget {
  final PreferenceManager manager;
  const MBT({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<MBT> createState() => _MBTState();
}

class _MBTState extends State<MBT> {
  final _formKey = GlobalKey<FormState>();

  final _controller = Get.find<StateController>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _selectedBank = "";
  final List<String> _mList = ["0712446586  (Airtimeslot - GTB)"];
  bool _paid = false;

  void onSelected(String value) {
    _selectedBank = value;
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
                      text: "Manual Bank Transfer",
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
              const SizedBox(height: 32.0),
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
                        horizontal: 16.0, vertical: 8.0),
                    child: ListView(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: TextPoppins(
                                  text:
                                      "Do ensure you provide the correct information before proceeding.",
                                  fontSize: 15,
                                  align: TextAlign.center,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 32.0,
                              ),
                              TextRoboto(
                                text: "Amount",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputMoney(
                                  hintText: "Amount (NGN)",
                                  onChanged: (val) {
                                    String? amt = val.replaceAll("₦ ", "");
                                    String filteredAmt =
                                        amt.replaceAll(",", "");
                                  },
                                  controller: _amountController,
                                  validator: (val) {
                                    if (val == null || val.toString().isEmpty) {
                                      return "Amount is required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextRoboto(
                                text: "Designated Bank",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedDropdownGender(
                                  onSelected: onSelected,
                                  items: _mList,
                                  placeholder: "Select",
                                  validator: (val) {
                                    if (val == null || val.toString().isEmpty) {
                                      return "Designated bank is required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextRoboto(
                                text: "Account Name",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputField(
                                  hintText: "Enter name",
                                  onChanged: (val) {},
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                  controller: _nameController,
                                  validator: (val) {
                                    if (val == null || val.toString().isEmpty) {
                                      return "Account name is required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              width: double.infinity,
                              child: RoundedButton(
                                text: "Continue",
                                press: () {
                                  if (_formKey.currentState!.validate()) {
                                    _submitRequest();
                                  }
                                },
                              ),
                            ),
                          ],
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

  _submitRequest() async {
    _controller.setLoading(true);
    String amt = _amountController.text.replaceAll("₦ ", "");

    Map _payload = {
      "amount": amt.replaceAll(",", ""),
      "designated_bank": _selectedBank,
      "payee_name": _nameController.text,
    };

    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      final resp = await APIService().fundWalletRequest(_payload, _token);
      _controller.setLoading(false);
      debugPrint("FUND MBT RESP :: ${resp.body}");

      if (resp.statusCode == 200) {
        Map<String, dynamic> _respMap = jsonDecode(resp.body);
        // Constants.toast(
        //     "Hi ${_respMap['data']['payee_name']}, ${_respMap['message']}");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message:
                    "Hi ${_respMap['data']['payee_name']}, ${_respMap['message']}",
              ),
            );
          },
        );
        
        _controller.onInit();
      } else {
        //Error occurred on login
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        ErrorResponse error = ErrorResponse.fromJson(errorMap);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: "${error.message}",
              ),
            );
          },
        );
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }

  //   _uploadToServer() async {
  //   _controller.setLoading(true);
  //   String amt = _amountController.text.replaceAll("₦ ", "");

  //   try {
  //     final _prefs = await SharedPreferences.getInstance();
  //     final _token = _prefs.getString("accessToken") ?? "";

  //     final req = await APIService().fundWalletRequest2(accessToken: _token);

  //     req.fields['amount'] = amt.replaceAll(",", "");
  //     req.fields['designated_bank'] = _selectedBank;
  //     req.fields['payee_name'] = _nameController.text;

  //     req.files.add(await http.MultipartFile.fromPath('image', ""));
  //     req.send().then((value) {
  //       http.Response.fromStream(value).then((resp) {
  //         try {
  //           // resp.body
  //           debugPrint("UPLOAD RESPNOSE::: :: ${resp.body}");
  //           _controller.setLoading(false);
  //           if (resp.statusCode == 200) {
  //             Map<String, dynamic> map = jsonDecode(resp.body);
  //             toast("${map['message']}");
  //           } else {
  //             Map<String, dynamic> errorMap = jsonDecode(resp.body);
  //             ErrorResponse error = ErrorResponse.fromJson(errorMap);
  //             toast("${error.message}");
  //           }
  //         } catch (e) {
  //           _controller.setLoading(false);
  //           debugPrint(e.toString());
  //         }
  //       });
  //     });
  //   } catch (e) {
  //     _controller.setLoading(false);
  //     debugPrint(e.toString());
  //   }
  // }
}
