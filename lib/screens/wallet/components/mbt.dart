import 'dart:convert';

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
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
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

  String _selectedBank = "GTB - 0598317536";
  bool _paid = false;

  void onSelected(String value) {
    _selectedBank = value;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        TextRoboto(
          text: "Fund your wallet via Manual Bank Transfer",
          fontSize: 18,
          align: TextAlign.center,
          fontWeight: FontWeight.w600,
        ),
        TextRoboto(
          text:
              "Only submit request, after successful transfer to the company's account.",
          fontSize: 13,
          color: Constants.accentColor,
          align: TextAlign.center,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextRoboto(
                text: "Amount",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              RoundedInputMoney(
                hintText: "Enter amount",
                onChanged: (val) {
                  // _computeDiscount(_selectedNetwork);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
                controller: _amountController,
              ),
              const SizedBox(
                height: 16.0,
              ),
              RoundedDropdownGender(
                placeholder: "Select account",
                onSelected: onSelected,
                items: const ["GTB - 0598317536", "Paycom(Opay) - 8148337436"],
              ),
              const SizedBox(
                height: 16.0,
              ),
              RoundedInputField(
                hintText: "Enter sender's name",
                onChanged: (val) {},
                controller: _nameController,
                capitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter sender\'s name';
                  }
                  return null;
                },
                inputType: TextInputType.name,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _paid,
                        onChanged: (checked) {
                          setState(() {
                            _paid = checked!;
                          });
                        },
                      ),
                      TextRoboto(
                        text: "I have paid",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              RoundedButton(
                text: "Submit Request",
                press: _paid
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _submitRequest();
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 75.0),
            ],
          ),
        ),
      ],
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
        Constants.toast("Hi ${_respMap['data']['payee_name']}, ${_respMap['message']}");
        Navigator.pop(context);
      } else {
        //Error occurred on login
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        ErrorResponse error = ErrorResponse.fromJson(errorMap);
        Constants.toast("${error.message}");
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
