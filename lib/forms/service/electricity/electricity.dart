import 'dart:convert';
import 'dart:io';

import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/inputs/rounded_dropdown_gender.dart';
import 'package:data_extra_app/components/inputs/rounded_input_meter_num.dart';
import 'package:data_extra_app/components/inputs/rounded_input_money.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/screens/services/selectors/network_selector.dart';
import 'package:data_extra_app/screens/services/summary/summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  bool _isNetworkErr = false;
  String _meterType = "";

  void _onSelected(val) {
    setState(() {
      _meterType = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: RoundedInputMeterNumber(
                hintText: "Meter number",
                onChanged: (val) {},
                controller: _meterNumController,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RoundedButton(
                      text: "Next",
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
              ),
            )
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
      "disco_id": _controller.selectedElectricityProvider.value['id'],
      "amount": amt.replaceAll(",", ""),
      "transaction_type": "electricity",
      "meter_number": _meterNumController.text,
      "meter_type": _meterType.toLowerCase(),
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
            type: "electricity",
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
