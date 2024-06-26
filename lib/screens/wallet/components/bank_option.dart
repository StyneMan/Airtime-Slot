import 'dart:convert';

import 'package:airtimeslot_app/components/dialogs/info_dialog.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_dropdown_bank.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawToBnnk extends StatefulWidget {
  WithdrawToBnnk({Key? key}) : super(key: key);

  @override
  State<WithdrawToBnnk> createState() => _WithdrawToBnnkState();
}

class _WithdrawToBnnkState extends State<WithdrawToBnnk> {
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  final _accNumController = TextEditingController();
  final _accNameController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedBank = "";
  String _selectedBankCode = "";

  bool shouldContinue = false;

  _onSelected(val) {
    var _mBank = _controller.banks.value.where(
      (element) => element['name'] == val,
    );
    setState(() {
      _selectedBank = val;
      _selectedBankCode = _mBank.first['code'];
    });
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
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 48),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: TextPoppins(
                        text: "Withdraw Funds",
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
                const SizedBox(height: 24.0),
                Expanded(
                  child: Card(
                    elevation: 0.0,
                    color: Colors.white.withOpacity(.9),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36.0),
                        topRight: Radius.circular(36.0),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView(
                        children: [
                          TextPoppins(
                            text: "Withdrawable Balance",
                            fontSize: 21,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          TextPoppins(
                            text: "Withdraw from your withdrawable wallet",
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextPoppins(
                                text: "Bank",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedDropdownBank(
                                  items: _controller.banks.value,
                                  onSelected: _onSelected,
                                  placeholder: "Select Bank",
                                  validator: (val) {
                                    if (val == null || val.toString().isEmpty) {
                                      return "Bank name is required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextPoppins(
                                text: "Account Number",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputField(
                                  inputType: TextInputType.number,
                                  hintText: "Enter account number",
                                  onChanged: (val) {},
                                  controller: _accNumController,
                                  validator: (val) {
                                    if (val == null || val.toString().isEmpty) {
                                      return "Account number is required";
                                    }
                                    return null;
                                  },
                                  suffix: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _verifyAccount();
                                      },
                                      child: const Text(
                                        'Verify',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextPoppins(
                                text: "Account Name",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: RoundedInputField(
                                  inputType: TextInputType.text,
                                  hintText: "Enter account name",
                                  capitalization: TextCapitalization.words,
                                  onChanged: (val) {},
                                  isEnabled: false,
                                  controller: _accNameController,
                                  validator: (val) {
                                    if (val == null || val.toString().isEmpty) {
                                      return "Account name is required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextPoppins(
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
                                    // print("SELCETD NEDWORK:: $_networkValue");
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
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const SizedBox(height: 21.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 21.0),
                  child: RoundedButton(
                    text: "Continue",
                    isEnabled: shouldContinue,
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        _withdrawFunds();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _verifyAccount() async {
    try {
      _controller.setLoading(true);

      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      print("BANK CODE :: $_selectedBankCode");

      Map _payload = {
        "account_number": _accNumController.text,
        "bank_code": _selectedBankCode
      };
      final resp =
          await APIService().verifyAccount(accessToken: _token, body: _payload);
      debugPrint("GH YTY :: ${resp.body}");
      _controller.setLoading(false);

      Map<String, dynamic> mapper = jsonDecode(resp.body);
      debugPrint("MESSAGE :: ${mapper['message']}");
      if (mapper['message'] != null) {
        Constants.toast('${mapper['message']}');
      }

      if (resp.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(resp.body);

        setState(() {
          _accNameController.text = map['data']['accountName'];
          shouldContinue = true;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }

  _withdrawFunds() async {
    _controller.setLoading(true);

    String amt = _amountController.text.replaceAll("₦ ", "");

    Map _payload = {
      "account_number": _accNumController.text,
      "amount": amt.replaceAll(",", ""),
      "bank_code": _selectedBankCode
    };

    final _prefs = await SharedPreferences.getInstance();
    final _token = _prefs.getString("accessToken") ?? "";

    try {
      final resp = await APIService().withdrawWallet(_payload, _token);
      debugPrint("WITHDRAWAL RESPONSE >> ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(resp.body);

        setState(() {
          _accNumController.text = "";
          _amountController.text = "";
          _selectedBankCode = "";
        });

        _controller.onInit();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: map['message'],
                goBack: true,
              ),
            );
          },
        );
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: errorMap['message'],
              ),
            );
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }
}
