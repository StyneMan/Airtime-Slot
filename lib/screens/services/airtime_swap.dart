import 'dart:convert';

import 'package:data_extra_app/components/dialogs/info_dialog.dart';
import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/inputs/rounded_input_money.dart';
import 'package:data_extra_app/components/inputs/rounded_phone_field.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/model/networks/network_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'selectors/network_selector.dart';

class AirtimeSwap extends StatefulWidget {
  final PreferenceManager manager;
  final String service;
  // ProductModel? product;
  AirtimeSwap({
    Key? key,
    required this.service,
    required this.manager,
    // required this.product,
  }) : super(key: key);

  @override
  State<AirtimeSwap> createState() => _AirtimeSwapState();
}

class _AirtimeSwapState extends State<AirtimeSwap> {
  final _controller = Get.find<StateController>();

  final _formKey = GlobalKey<FormState>();

  List<dynamic> _mainList = [];

  // int _amountRes = 0;
  String _networkValue = "";
  NetworkProducts? _selectedNetwork;

  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isNetworkErr = false;

  Future _init() async {
    final prefs = await SharedPreferences.getInstance();
    final String _token = prefs.getString('accessToken') ?? "";

    final resp = await APIService().airtimeCash(_token);

    Map<String, dynamic> map = jsonDecode(resp.body);
    _controller.airtimeSwapData.value = map['data'];
    // debugPrint("AIRTIME CASH ${resp.body}");
    return resp;
  }

  @override
  void initState() {
    _controller.airtimeSwapNumber.value = "";
    _controller.airtimeSwapRate.value = "";
    _controller.airtimeSwapResultantAmt.value = "0.0";
    super.initState();
  }

  _airtimeSwap() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    String? amt = _amountController.text.replaceAll("₦ ", "");
    String filteredAmt = amt.replaceAll(",", "");

    debugPrint(
        "SELECTED NETWORK <<<>>> ${_controller.selectedAirtimeProvider.value['id']}");

    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      Map _payload = {
        "amount": amt.replaceAll(",", ""),
        "network_id": "${_controller.selectedAirtimeProvider.value['id']}",
        "phone": _phoneController.text
      };

      final resp = await APIService().airtimeCashRequest(_payload, _token);
      debugPrint("AIRTIME RESPONSE <<<>>> ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(resp.body);

        // setState(() {
        _amountController.clear();
        _phoneController.clear();
        // });

        _controller.selectedAirtimeProvider.value = {};
        _controller.airtimeSwapData.value = [];
        _controller.airtimeSwapRate.value = "";
        _controller.airtimeSwapNumber.value = "";
        _controller.airtimeSwapResultantAmt.value = "0.0";

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: map['message'],
              ),
            );
          },
        );

        _controller.onInit();
      } else if (resp.statusCode == 422) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: map['message'],
              ),
            );
          },
        );
      } else {
        Map<String, dynamic> map = jsonDecode(resp.body);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: InfoDialog(
                message: map['message'],
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

  // @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder<dynamic>(
          future: _init(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: TextPoppins(text: "Loading ...", fontSize: 16),
                ),
              );
            }

            if (snap.hasError) {
              Future.delayed(const Duration(seconds: 2), () {
                _controller.hasInternetAccess.value = false;
              });
              return Container(
                color: Constants.accentColor,
                width: double.infinity,
                height: double.infinity,
                child: const Center(
                  child: Text(
                    "An error occurred. Check your internet connection",
                  ),
                ),
              );
            }

            if (!snap.hasData) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Image.asset(
                    "assets/images/no_record.png",
                    width: 275,
                  ),
                ),
              );
            }

            final data = snap.requireData;
            // debugPrint("SSDS:: ? ${data.body}");
            Map<String, dynamic> _map = jsonDecode(data.body);
            _mainList = _map['data'];
            // _subList = _map['data']?.sublist(0, 4);

            return Obx(
              () => Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    TextRoboto(
                      text: "Securely Swap your airtime here",
                      fontSize: 21,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      align: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextRoboto(
                      text: "Network",
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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
                            setState(() {
                              _amountController.text = "";
                              _controller.airtimeSwapResultantAmt.value = "0.0";
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NetworkSelector(
                                  type: "airtime-swap",
                                  list:
                                      _controller.airtimeData.value['networks'],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _controller.selectedAirtimeProvider.value.isEmpty
                                  ? TextPoppins(
                                      text: "Service provider",
                                      fontSize: 15,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            "${Constants.baseURL}${_controller.selectedAirtimeProvider.value['icon']}",
                                            width: 24,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        TextPoppins(
                                          text:
                                              "${_controller.selectedAirtimeProvider.value['name']}",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextRoboto(
                          text: "Rate: ${_controller.airtimeSwapRate.value}%",
                          fontSize: 12,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 4.0,
                            ),
                            TextRoboto(
                              text: _controller.airtimeSwapNumber
                                  .value, //"${_affectedItems[0]['value']}",
                              fontSize: 12,
                              color: Constants.secondaryColor,
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 21.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextRoboto(
                          text: "Amount",
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("gives you"),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              '${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(_controller.airtimeSwapResultantAmt.value))}',
                              style: const TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: RoundedInputMoney(
                        hintText: "Amount (NGN)",
                        onChanged: (val) {
                          String? amt = val.replaceAll("₦ ", "");
                          String filteredAmt = amt.replaceAll(",", "");
                          // print("SELCETD NEDWORK:: $_networkValue");
                          // print(
                          //     "SELCETED RATE:: ${_controller.airtimeSwapRate.value}");
                          // print("CURRENT AMOUNT TF:: $val");

                          //In real time here
                          if (_controller
                              .selectedAirtimeProvider.value.isNotEmpty) {
                            int rateVal =
                                int.parse(_controller.airtimeSwapRate.value);
                            double decimal = (rateVal / 100);
                            var reduce =
                                int.parse(amt.replaceAll(",", "")) * decimal;

                            _controller.airtimeSwapResultantAmt.value =
                                "$reduce";
                          }
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
                      height: 21.0,
                    ),
                    TextRoboto(
                      text: "From Phone",
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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
                      height: 21,
                    ),
                    RoundedButton(
                      text: "Continue",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: TextPoppins(
                                text: "Airtime Swap",
                                fontSize: 18,
                              ),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.96,
                                height: 100,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: "I ",
                                        style: const TextStyle(
                                          color: Colors.black45,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                "${widget.manager.getUser()['name']}",
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const TextSpan(
                                            text:
                                                " confirm that I have transferred ",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " ${_amountController.text} ",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: "to ",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                " ${_controller.airtimeSwapNumber} ",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: TextRoboto(
                                      text: "Cancel",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _airtimeSwap();
                                    },
                                    child: TextRoboto(
                                      text: "Continue",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          //
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
