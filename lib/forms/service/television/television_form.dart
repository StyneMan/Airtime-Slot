import 'dart:convert';
import 'dart:io';

import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/inputs/rounded_input_meter_num.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/screens/services/selectors/network_selector.dart';
import 'package:data_extra_app/screens/services/selectors/package_selector.dart';
import 'package:data_extra_app/screens/services/summary/summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isNetworkErr = false, _isPlanErr = false, _shouldContinue = false;
  String _customerName = "",
      _customerNumber = "",
      _currentBouquet = "",
      _dueDate = "";

  _verifyTV() async {
    try {
      _controller.setLoading(true);
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      // print("BANK CODE :: ${_controller.selectedTelevisionProvider.value}");

      Map _payload = {
        "isn": _cardController.text,
        "network_id": _controller.selectedTelevisionProvider.value['id']
      };
      final response =
          await APIService().verifyCableTV(body: _payload, accessToken: _token);
      _controller.setLoading(false);
      print("BTV VERIFY RESPONSE  :: ${response.body}");

      Map<String, dynamic> mapper = jsonDecode(response.body);
      debugPrint("MESSAGE :: ${mapper['message']}");
      if (mapper['message'] != null) {
        Constants.toast('${mapper['message']}');
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);

        setState(() {
          _customerNumber = map['data']['Customer_Number'];
          _customerName = map['data']['Customer_Name'];
          _currentBouquet = map['data']['Current_Bouquet'];
          _dueDate = map['data']['Due_Date'];
          _shouldContinue = true;
        });
      } else {
        setState(() {
          _customerNumber = "";
          _customerName = "";
          _currentBouquet = "";
          _dueDate = "";
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
                suffix: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _verifyTV();
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
            Expanded(
              child: Padding(
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
                                text: "Customer Number",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              TextRoboto(text: _customerNumber, fontSize: 13),
                              const SizedBox(height: 16.0),
                              const SizedBox(height: 8.0),
                              TextRoboto(
                                text: "Current Bouquet",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              TextRoboto(text: _currentBouquet, fontSize: 13),
                              const SizedBox(height: 16.0),
                              const SizedBox(height: 8.0),
                              TextRoboto(
                                text: "Due Date",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              TextRoboto(text: _dueDate, fontSize: 13),
                              const SizedBox(height: 16.0)
                            ],
                          ),
                    RoundedButton(
                      text: "Next",
                      isEnabled: _shouldContinue,
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
    FocusManager.instance.primaryFocus?.unfocus();
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

        //revalidate transactions
        _controller.transactions.value.clear();
        await APIService().fetchTransactions(widget.manager.getAccessToken());

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
    } on SocketException {
      _controller.hasInternetAccess.value = false;
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }
}
