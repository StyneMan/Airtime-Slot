import 'dart:convert';

import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_dropdown_bank.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/banks/banks.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Withdraw extends StatefulWidget {
  final PreferenceManager manager;
  const Withdraw({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountNumController = TextEditingController();
  String _selectedBank = "Access Bank";
  var _bankCode;

  void onSelected(String bank) {
    var arr = banks.where((element) => element['name'] == bank);
    setState(() {
      _selectedBank = bank;
      _bankCode = arr.elementAt(0)['code'];
    });
  }

  _withdrawFunds() async {
    _controller.setLoading(true);

    String amt = _amountController.text.replaceAll("₦ ", "");

    Map _payload = {
      "account_number": _accountNumController.text,
      "amount": amt.replaceAll(",", ""),
      "bank_code": _bankCode ?? "0"
    };

    final _prefs = await SharedPreferences.getInstance();
    final _token = _prefs.getString("accessToken") ?? "";

    try {
      final resp = await APIService().withdrawWallet(_payload, _token);
      debugPrint("WITHDRAWAL RESPONSE >> ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Constants.toast("Operation successful");
        Navigator.pop(context);
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        Constants.toast(errorMap['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
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
          text: "WithDraw Funds".toUpperCase(),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextRoboto(
            text: "Withdrawable Balance",
            fontSize: 14,
            align: TextAlign.center,
          ),
          Text(
            "${Constants.nairaSign(context).currencySymbol}${widget.manager.getUser()['withdrawable_balance']}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextRoboto(
            text: "Withdraw from your withdrawable wallet",
            fontSize: 14,
            align: TextAlign.center,
          ),
          const SizedBox(
            height: 32.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextRoboto(
                  text: "Bank",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                RoundedDropdownBank(
                  placeholder: "Select bank",
                  onSelected: onSelected,
                  items: banks,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextRoboto(
                  text: "Account number",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                RoundedInputField(
                  hintText: "",
                  onChanged: (e) {
                    debugPrint("${e.length}");
                  },
                  controller: _accountNumController,
                  validator: (val) {
                    // print("VAK $val");
                    if (val.toString().length < 10) {
                      return "Enter a valid account number";
                    }
                    if (val.toString().contains(" ")) {
                      return "Number not valid";
                    }

                    return null;
                  },
                  inputType: TextInputType.number,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextRoboto(
                  text: "Amount",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                RoundedInputMoney(
                  hintText: "",
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
                  height: 10.0,
                ),
                RoundedButton(
                  text: "CONTINUE",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      _withdrawFunds();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
