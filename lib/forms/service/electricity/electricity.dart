import 'dart:convert';
import 'dart:io';

import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_dropdown_gender.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_meter_num.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/services/selectors/network_selector.dart';
import 'package:airtimeslot_app/screens/services/summary/summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElectricityForm extends StatefulWidget {
  final PreferenceManager manager;
  ElectricityForm({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ElectricityForm> createState() => _ElectricityFormState();
}

class _ElectricityFormState extends State<ElectricityForm> {
  final _amountController = TextEditingController();
  final _meterNumController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkErr = false, _shouldContinue = false;
  String _meterType = "";
  String _customerName = "", _customerAddress = "", _customerPhone = "";
  String? _meterNumber = "";

  void _onSelected(val) {
    setState(() {
      _meterType = val;
    });
  }

  _verifyElectricity() async {
    try {
      _controller.setLoading(true);
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      print("BANK CODE :: ${_controller.selectedElectricityProvider.value}");

      Map _payload = {
        "meter_number": _meterNumController.text.replaceAll(' ', ''),
        "meter_type": _meterType.toLowerCase(),
        "disco_id": _controller.selectedElectricityProvider.value['id']
      };
      final response = await APIService()
          .verifyElectricity(body: _payload, accessToken: _token);
      _controller.setLoading(false);

      print("BTV VERIFY RESPONSE  :: ${response.body}");

      Map<String, dynamic> mapper = jsonDecode(response.body);
      // debugPrint("MESSAGE :: ${mapper['message']}");
      if (mapper['message'] != null) {
        Constants.toast('${mapper['message'] ?? ""}');
      }

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        debugPrint("SUCCESS :");

        Map<String, dynamic> map = jsonDecode(response.body);

        debugPrint("SUCCESS MAPPER : $map");

        setState(() {
          _shouldContinue = true;
          _customerAddress = map['data']['Address'];
          _customerName = map['data']['Customer_Name'];
          _customerPhone = map['data']['Customer_Phone'];
          _meterNumber = map['data']['Meter_Number'];
        });
      } else {
        setState(() {
          _customerAddress = "";
          _customerName = "";
          _customerPhone = "";
          _meterNumber = "";
          _shouldContinue = false;
        });
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _formKey,
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Constants.accentColor,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NetworkSelector(
                          type: "electricity",
                          list: _controller.electricityData['networks'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _controller.selectedElectricityProvider.value.isEmpty
                          ? TextPoppins(
                              text: "Electricity company",
                              fontSize: 15,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    "${Constants.baseURL}${_controller.selectedElectricityProvider.value['icon']}",
                                    width: 24,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/logo_big.png',
                                      width: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.64,
                                  child: Wrap(
                                    children: [
                                      TextPoppins(
                                        text:
                                            "${_controller.selectedElectricityProvider.value['name']}",
                                        fontSize: 15,
                                        color: Colors.black,
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        size: 16,
                        color: _isNetworkErr ? Colors.red : Colors.grey,
                      )
                    ],
                  ),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.all(16.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: RoundedInputMoney(
                hintText: "Amount (NGN)",
                onChanged: (val) {},
                controller: _amountController,
                validator: (val) {},
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: RoundedDropdownGender(
                placeholder: "Meter type",
                validator: (val) {},
                onSelected: _onSelected,
                items: const ["Postpaid", "Prepaid"],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: RoundedInputMeterNumber(
                hintText: "Meter number",
                onChanged: (val) {},
                controller: _meterNumController,
                validator: (val) {},
                suffix: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _verifyElectricity();
                    },
                    child: const Text(
                      'Verify',
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  !_shouldContinue
                      ? const SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            TextRoboto(
                              text: "Customer Name",
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            TextRoboto(text: _customerName, fontSize: 13),
                            const SizedBox(height: 16.0),
                            const SizedBox(height: 8.0),
                            TextRoboto(
                              text: "Address",
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            TextRoboto(text: _customerAddress, fontSize: 13),
                            const SizedBox(height: 16.0),
                            const SizedBox(height: 8.0),
                            (_customerPhone.isEmpty ||
                                    _customerPhone.toString().toLowerCase() ==
                                        "null")
                                ? TextRoboto(
                                    text: "Meter Number",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  )
                                : TextRoboto(
                                    text: "Phone Number",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                            TextRoboto(
                                text: (_customerPhone.isEmpty ||
                                        _customerPhone
                                                .toString()
                                                .toLowerCase() ==
                                            "null")
                                    ? _meterNumController.text
                                        .replaceAll(" ", "")
                                    : _customerPhone,
                                fontSize: 13),
                            const SizedBox(height: 16.0)
                          ],
                        ),
                  const SizedBox(height: 48),
                  RoundedButton(
                    text: "Next",
                    isEnabled: _shouldContinue,
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        if (_controller
                            .selectedElectricityProvider.value.isEmpty) {
                          setState(() {
                            _isNetworkErr = true;
                          });
                        } else {
                          setState(() {
                            _isNetworkErr = false;
                          });
                          _initiateTransaction();
                        }
                      }
                      if (_controller
                          .selectedElectricityProvider.value.isEmpty) {
                        setState(() {
                          _isNetworkErr = true;
                        });
                      } else {
                        setState(() {
                          _isNetworkErr = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _initiateTransaction() async {
    _controller.setLoading(true);
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    String? amt = _amountController.text.replaceAll("₦ ", "");
    String filteredAmt = amt.replaceAll(",", "");
    int price = int.parse(amt.replaceAll(",", ""));

    Map _payload = {
      "disco_id": _controller.selectedElectricityProvider.value['id'],
      "amount": filteredAmt,
      "transaction_type": "electricity",
      "meter_number": _meterNumController.text.replaceAll(" ", ""),
      "meter_type": _meterType.toLowerCase(),
    };

    try {
      final response = await APIService()
          .startTransaction(_payload, widget.manager.getAccessToken());

      debugPrint("RES Electricity? ==>>>> ${response.body}");
      _controller.setLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constants.toast(map['message']);

        //update profile
        _controller.onInit();
        //revalidate transactions
        _controller.transactions.value.clear();
        await APIService().fetchTransactions(widget.manager.getAccessToken());

        //Navigate to transaction info screen
        Get.to(
          TransactionSummary(
            type: "electricity",
            data: map['data'],
            manager: widget.manager,
            address: _customerAddress,
            customerName: _customerName,
            meterSmartcardNumber:
                (_meterNumber ?? _meterNumController.text).replaceAll(" ", ""),
          ),
          transition: Transition.cupertino,
        );
      } else {
        Map<String, dynamic> error = jsonDecode(response.body);
        Constants.toast(error['message']);
      }
    } on SocketException {
      _controller.hasInternetAccess.value = false;
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }
}
