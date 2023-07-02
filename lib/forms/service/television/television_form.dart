import 'dart:convert';

import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_meter_num.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/services/selectors/network_selector.dart';
import 'package:airtimeslot_app/screens/services/selectors/package_selector.dart';
import 'package:airtimeslot_app/screens/services/summary/summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TelevisionForm extends StatefulWidget {
  final PreferenceManager manager;
  TelevisionForm({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<TelevisionForm> createState() => _TelevisionFormState();
}

class _TelevisionFormState extends State<TelevisionForm> {
  final _cardController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _controller = Get.find<StateController>();
  bool _isNetworkErr = false, _isPlanErr = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16.0,
            ),
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
                          type: "cabletv",
                          list: _controller.cableData['networks'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _controller.selectedTelevisionProvider.value.isEmpty
                          ? TextPoppins(
                              text: "Service provider",
                              fontSize: 15,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    "${Constants.baseURL}${_controller.selectedTelevisionProvider.value['icon']}",
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
                                TextPoppins(
                                  text:
                                      "${_controller.selectedTelevisionProvider.value['name']}",
                                  fontSize: 15,
                                  color: Colors.black,
                                )
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Constants.accentColor,
                ),
                child: TextButton(
                  onPressed:
                      _controller.selectedTelevisionProvider.value.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PackageSelector(
                                    list: _controller.selectedTelevisionProvider
                                        .value['products'],
                                    type: "cabletv",
                                    image: _controller
                                        .selectedTelevisionProvider
                                        .value['icon'],
                                  ),
                                ),
                              );
                            },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _controller.selectedTelevisionPlan.value.isEmpty
                          ? TextPoppins(
                              text: "Subscription Package/Bouquet",
                              fontSize: 15,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text:
                                        "[${_controller.selectedTelevisionProvider.value['name']}] ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "${_controller.selectedTelevisionPlan.value['name']}"
                                                    .length >
                                                32
                                            ? "${_controller.selectedTelevisionPlan.value['name']}"
                                                    .substring(0, 31) +
                                                "..."
                                            : "${_controller.selectedTelevisionPlan.value['name']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        size: 16,
                        color: _isPlanErr ? Colors.red : Colors.grey,
                      )
                    ],
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Constants.accentColor,
                ),
                child: TextButton(
                  onPressed:
                      _controller.selectedTelevisionProvider.value.isEmpty
                          ? null
                          : () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _controller.selectedTelevisionPlan.value.isEmpty
                          ? TextPoppins(
                              text: "Amount (NGN)",
                              fontSize: 15,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoney(_controller.selectedTelevisionPlan.value['amount'])}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontFamily: "Inter",
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: RoundedInputMeterNumber(
                hintText: "Smartcard/IUC number",
                onChanged: (val) {},
                controller: _cardController,
                validator: (val) {
                  if (val == null || val.toString().isEmpty) {
                    return "Card number is required";
                  }
                  return null;
                },
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
                              .selectedTelevisionProvider.value.isEmpty) {
                            setState(() {
                              _isNetworkErr = true;
                              _isPlanErr = true;
                            });
                          } else if (_controller
                              .selectedTelevisionPlan.value.isEmpty) {
                            setState(() {
                              _isNetworkErr = false;
                              _isPlanErr = true;
                            });
                          } else {
                            setState(() {
                              _isNetworkErr = false;
                              _isPlanErr = false;
                            });
                            _initiateTransaction();
                          }
                        }
                        if (_controller
                            .selectedTelevisionProvider.value.isEmpty) {
                          setState(() {
                            _isNetworkErr = true;
                            _isPlanErr = true;
                          });
                        } else {
                          setState(() {
                            _isNetworkErr = false;
                          });
                          if (_controller
                              .selectedTelevisionPlan.value.isEmpty) {
                            setState(() {
                              _isPlanErr = true;
                            });
                          } else {
                            setState(() {
                              _isPlanErr = false;
                            });
                          }
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
    _controller.setLoading(true);
    Map _payload = {
      "network_id": _controller.selectedTelevisionProvider.value['id'],
      "isn": _cardController.text,
      "product_id": _controller.selectedTelevisionPlan.value['id'],
      "transaction_type": "cable_tv",
      "amount": 0,
    };

    try {
      final response = await APIService()
          .startTransaction(_payload, widget.manager.getAccessToken());

      debugPrint("RES ==>>>> ${response.body}");
      _controller.setLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constants.toast(map['message']);
        //update profile
        _controller.onInit();

        //Navigate to transaction info screen
        Get.to(
          TransactionSummary(
            type: "cable_tv",
            data: map['data'],
            manager: widget.manager,
          ),
          transition: Transition.cupertino,
        );
      } else {
        Map<String, dynamic> error = jsonDecode(response.body);
        Constants.toast(error['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }
}
