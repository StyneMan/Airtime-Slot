import 'dart:convert';
import 'dart:io';

import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_phone_field.dart';
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

class InternetDataForm extends StatefulWidget {
  final PreferenceManager manager;
  InternetDataForm({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<InternetDataForm> createState() => _InternetDataFormState();
}

class _InternetDataFormState extends State<InternetDataForm> {
  final _phoneController = TextEditingController();
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
                          type: "data",
                          list: _controller.internetData['networks'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _controller.selectedDataProvider.value.isEmpty
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
                                    "${Constants.baseURL}${_controller.selectedDataProvider.value['icon']}",
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
                                      "${_controller.selectedDataProvider.value['name']}",
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
                  onPressed: _controller.selectedDataProvider.value.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackageSelector(
                                list: _controller
                                    .selectedDataProvider.value['products'],
                                type: "data",
                                image: _controller
                                    .selectedDataProvider.value['icon'],
                              ),
                            ),
                          );
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _controller.selectedDataPlan.value.isEmpty
                          ? TextPoppins(
                              text: "Data Plans",
                              fontSize: 15,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.68,
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                          "[${_controller.selectedDataPlan.value['name']}] ",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${_controller.selectedDataPlan.value['name']}"
                                                      .length >
                                                  32
                                              ? "${_controller.selectedDataPlan.value['name']}"
                                                      .substring(0, 31) +
                                                  "..."
                                              : "${_controller.selectedDataPlan.value['name']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
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
                  onPressed: _controller.selectedDataProvider.value.isEmpty
                      ? null
                      : () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _controller.selectedDataPlan.value.isEmpty
                          ? TextPoppins(
                              text: "Amount (NGN)",
                              fontSize: 15,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoney(_controller.selectedDataPlan.value['amount'])}",
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
              child: RoundedPhoneField(
                inputType: TextInputType.number,
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
                          if (_controller.selectedDataProvider.value.isEmpty) {
                            setState(() {
                              _isNetworkErr = true;
                              _isPlanErr = true;
                            });
                          } else if (_controller
                              .selectedDataPlan.value.isEmpty) {
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
                        if (_controller.selectedDataProvider.value.isEmpty) {
                          setState(() {
                            _isNetworkErr = true;
                            _isPlanErr = true;
                          });
                        } else {
                          setState(() {
                            _isNetworkErr = false;
                          });
                          if (_controller.selectedDataPlan.value.isEmpty) {
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
     FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    Map _payload = {
      "network_id": _controller.selectedDataProvider.value['id'],
      "phone": _phoneController.text,
      "product_id": _controller.selectedDataPlan.value['id'],
      "transaction_type": "data",
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

        //revalidate transactions
        _controller.transactions.value.clear();
        await APIService().fetchTransactions(widget.manager.getAccessToken());

        //Navigate to transaction info screen
        Get.to(
          TransactionSummary(
            type: "data",
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
