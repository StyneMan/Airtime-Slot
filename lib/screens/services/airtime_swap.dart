import 'dart:convert';

import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_dropdown.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_field.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/networks/network_product.dart';
import 'package:airtimeslot_app/model/products/product_model.dart';
import 'package:airtimeslot_app/model/products/product_response.dart';
import 'package:airtimeslot_app/screens/account/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AirtimeSwap extends StatefulWidget {
  final PreferenceManager manager;
  final String service;
  ProductModel? product;
  AirtimeSwap({
    Key? key,
    required this.service,
    required this.manager,
    required this.product,
  }) : super(key: key);

  @override
  State<AirtimeSwap> createState() => _AirtimeSwapState();
}

class _AirtimeSwapState extends State<AirtimeSwap> {
  final _controller = Get.find<StateController>();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> _mainList = [];

  // int _amountRes = 0;
  String _networkValue = "";
  NetworkProducts? _selectedNetwork;

  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();

  Future _init() async {
    final prefs = await SharedPreferences.getInstance();
    final String _token = prefs.getString('accessToken') ?? "";

    final resp = await APIService().airtimeCash(_token);
    // debugPrint("AIRTIME CASH ${resp.body}");
    return resp;
  }

  // ProductModel? _filterProduct() {
  //   List<ProductModel>? products = [];
  //   if (_controller.products != null) {
  //     ProductResponse body = ProductResponse.fromJson(_controller.products!);
  //     products = body.data;

  //     var filtered = products?.where((element) => element.name == "airtime");
  //     return filtered?.first;
  //   }
  // }

  @override
  void initState() {
    _controller.airtimeSwapNumber.value = "";
    _controller.airtimeSwapRate.value = "";
    _controller.airtimeSwapResultantAmt.value = "0.0";
    super.initState();
  }

  void setSelected(String val, NetworkProducts? network) {
    // debugPrint("JUST SELECTED NOW::: ${network?.products?.length}");
    // debugPrint("JUST SELECTED VALUE::: $val");

    // setState(() {
    _networkValue = val;
    _selectedNetwork = network;
    // });

    ///Now filter through second list
    final arr = _mainList.where(
      (element) => element['key'].toString().toLowerCase().startsWith(
            val.toLowerCase(),
          ),
    );

    final arrRate = arr.where((element) =>
        element['key'].toString().toLowerCase() ==
        "${val.toLowerCase()}_percentage");

    final arrNumber = arr.where((element) =>
        element['key'].toString().toLowerCase() ==
        "${val.toLowerCase()}_number");

    _controller.airtimeSwapRate.value = arrRate.first['value'];
    _controller.airtimeSwapNumber.value = arrNumber.first['value'];

    String? amt = _amountController.text.replaceAll("₦ ", "");
    String filteredAmt = amt.replaceAll(",", "");

    int rateVal = int.parse("${arrRate.first['value']}");
    double decimal = (rateVal / 100);
    var reduce = int.parse(amt.replaceAll(",", "")) * decimal;
    // var result = int.parse(amt.replaceAll(",", "")) - reduce;

    _controller.airtimeSwapResultantAmt.value = "$reduce";
  }

  _airtimeSwap() async {
    _controller.setLoading(true);
    String? amt = _amountController.text.replaceAll("₦ ", "");
    String filteredAmt = amt.replaceAll(",", "");

    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      Map _payload = {
        "amount": amt.replaceAll(",", ""),
        "network_id": "1",
        "phone": "08071239914"
      };

      final resp = await APIService().airtimeCashRequest(_payload, _token);
      debugPrint("AIRTIME RESPONSE <<<>>> ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Constants.toast("Operation successful");
      } else if (resp.statusCode == 422) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);
      } else {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: TextRoboto(
          text: "Airtime Swap".toUpperCase(),
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
      body: widget.manager.getUser()['has_kyc']
          ? SizedBox(
              child: FutureBuilder<dynamic>(
                  future: _init(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: Constants.accentColor,
                        width: double.infinity,
                        height: double.infinity,
                        child: const Center(
                          child: Text("Please wait ..."),
                        ),
                      );
                    }

                    if (snap.hasError) {
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
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            TextRoboto(
                              text: "Convert your airtime to cash",
                              fontSize: 16,
                              align: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextRoboto(
                              text: "Network",
                              fontSize: 16,
                              color: Constants.primaryColor,
                            ),
                            // RoundedDropdown(
                            //   type: widget.service,
                            //   placeholder: "Select network",
                            //   networks: _filterProduct()?.networks ?? [],
                            //   onSelected: setSelected,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextRoboto(
                                  text:
                                      "Rate: ${_controller.airtimeSwapRate.value}%",
                                  fontSize: 12,
                                  color: Constants.primaryColor,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.arrow_right_to_line_alt,
                                    ),
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
                                  color: Constants.primaryColor,
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
                            RoundedInputMoney(
                              hintText: "Enter amount",
                              onChanged: (val) {
                                String? amt = val.replaceAll("₦ ", "");
                                String filteredAmt = amt.replaceAll(",", "");
                                // print("SELCETD NEDWORK:: $_networkValue");
                                // print(
                                //     "SELCETED RATE:: ${_controller.airtimeSwapRate.value}");
                                // print("CURRENT AMOUNT TF:: $val");

                                //In real time here
                                if (_networkValue.isNotEmpty) {
                                  int rateVal = int.parse(
                                      _controller.airtimeSwapRate.value);
                                  double decimal = (rateVal / 100);
                                  var reduce =
                                      int.parse(amt.replaceAll(",", "")) *
                                          decimal;

                                  _controller.airtimeSwapResultantAmt.value =
                                      "$reduce";
                                }
                              },
                              enabled: true,
                              icon: CupertinoIcons.money_dollar_circle_fill,
                              controller: _amountController,
                              validator: (newVal) {
                                if (newVal.toString().isEmpty) {
                                  return "Amount is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 21.0,
                            ),
                            TextRoboto(
                              text: "Phone number to debit from",
                              fontSize: 16,
                              color: Constants.primaryColor,
                            ),
                            RoundedInputField(
                              hintText: "",
                              onChanged: (val) {},
                              icon: CupertinoIcons.phone_circle_fill,
                              controller: _phoneController,
                              inputType: TextInputType.number,
                              validator: (newVal) {
                                if (newVal.toString().isEmpty) {
                                  return "Phone number is required";
                                }
                                if (newVal.toString().length < 11) {
                                  return "Phone number is not valid";
                                }
                                return null;
                              },
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.96,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                    text:
                                                        " ${_amountController.text} ",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
            )
          : SizedBox(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextRoboto(
                            text: "KYC Required",
                            fontSize: 21,
                            color: Constants.primaryColor,
                            align: TextAlign.center,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          TextRoboto(
                            text: "Kindly complete KYC to Continue",
                            fontSize: 15,
                            align: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          RoundedButton(
                            text: "Proceed",
                            press: () {
                              _controller.selectTab(
                                Account(
                                  manager: widget.manager,
                                ),
                                _controller.pageKeys[3],
                                3,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: TextRoboto(
                        text: "Convert your airtime to cash",
                        fontSize: 16,
                        align: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
