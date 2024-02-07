import 'dart:convert';
import 'dart:io';

import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/inputs/rounded_phone_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/services/summary/summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirtimeForm extends StatefulWidget {
  final String type;
  final PreferenceManager manager;
  const AirtimeForm({
    Key? key,
    required this.type,
    required this.manager,
  }) : super(key: key);

  @override
  State<AirtimeForm> createState() => _AirtimeFormFormState();
}

class _AirtimeFormFormState extends State<AirtimeForm> {
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;

  _setSelected(int index) {
    setState(() => _selectedIndex = (index + 1));
  }

  _selectNetwork(var network) {
    _controller.selectedAirtimeProvider.value = network;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 16.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: RoundedPhoneField(
                inputType: TextInputType.phone,
                hintText: "Phone number",
                onChanged: (val) {},
                controller: _phoneController,
                validator: (val) {
                  if (val == null || val.toString().isEmpty) {
                    return "Phone number is required";
                  }
                  return null;
                },
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Constants.accentColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      _setSelected(index);
                      _selectNetwork(
                          _controller.airtimeData.value['networks'][index]);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.network(
                                "${Constants.baseURL}${_controller.airtimeData.value['networks'][index]['icon']}",
                                width: 24,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            TextPoppins(
                              text:
                                  "${_controller.airtimeData.value['networks'][index]['name']}",
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.check_circle,
                          size: 18,
                        )
                      ],
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: index == (_selectedIndex - 1)
                          ? Colors.green
                          : Constants.checkBg,
                      padding: const EdgeInsets.all(16.0),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 10.0,
              ),
              itemCount:
                  (_controller.airtimeData.value['networks']?.length ?? 0),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.125,
            ),
            RoundedButton(
              text: "Next",
              press: () {
                if (_formKey.currentState!.validate()) {
                  if (_selectedIndex == 0) {
                    Constants.toast("Network provider not selected!");
                  } else {
                    _initiateTransaction();
                  }
                }
                if (_selectedIndex == 0) {
                  Constants.toast("Network provider not selected!");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _initiateTransaction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    String? amt = _amountController.text.replaceAll("₦ ", "");
    String filteredAmt = amt.replaceAll(",", "");
    int price = int.parse(amt.replaceAll(",", ""));

    Map _payload = {
      "network_id": _controller.selectedAirtimeProvider.value['id'],
      "phone": _phoneController.text,
      "amount": amt.replaceAll(",", ""),
      "transaction_type": "airtime",
    };

    try {
      final response = await APIService()
          .startTransaction(_payload, widget.manager.getAccessToken());

      debugPrint("RES AIRRTIME? ==>>>> ${response.body}");
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
            type: "airtime",
            data: map['data'],
            manager: widget.manager,
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
