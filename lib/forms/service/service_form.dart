import 'dart:convert';

import 'package:data_extra_app/components/inputs/rounded_button.dart';
import 'package:data_extra_app/components/inputs/rounded_dropdown.dart';
import 'package:data_extra_app/components/inputs/rounded_dropdown_gender.dart';
import 'package:data_extra_app/components/inputs/rounded_dropdown_product.dart';
import 'package:data_extra_app/components/inputs/rounded_input_field.dart';
import 'package:data_extra_app/components/inputs/rounded_input_meter_num.dart';
import 'package:data_extra_app/components/inputs/rounded_input_money.dart';
import 'package:data_extra_app/components/inputs/rounded_phone_field.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/database/database_handler.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/model/error/error.dart';
import 'package:data_extra_app/model/networks/mproducts.dart';
import 'package:data_extra_app/model/networks/network_product.dart';
import 'package:data_extra_app/model/products/product_model.dart';
import 'package:data_extra_app/model/transactions/transaction_response.dart';
import 'package:data_extra_app/screens/services/confirm_transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceForm extends StatefulWidget {
  final bool isAuthenticated;
  final String service;
  final String token;
  final ProductModel? product;
  final String? mAmount;

  const ServiceForm({
    Key? key,
    this.mAmount,
    required this.token,
    required this.service,
    this.product,
    required this.isAuthenticated,
  }) : super(key: key);

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  String _networkValue = "";
  String _productName = "";
  final int _productAmount = 0;
  final String _countryCode = "+234";
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final TextEditingController? _amountFixedController = TextEditingController();
  final TextEditingController? _amountController = TextEditingController();
  final TextEditingController? _emailController = TextEditingController();
  final TextEditingController _meterNumController = TextEditingController();
  final TextEditingController _smartCardNumController = TextEditingController();
  NetworkProducts? _selectedNetwork;
  MProduct? _selectedProduct;
  // double _discountAmt = 0.0;
  String _discountPercent = "";
  bool _isLoggedIn = false;
  List<MProduct>? _mproducts = [];
  final _controller = Get.find<StateController>();

  String _meterType = "Prepaid";

  void onSelectedMeter(String type) {
    setState(() {
      _meterType = type;
    });
  }

  _initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoggedIn =
            prefs.getString('accessToken').toString().isEmpty ? false : true;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setSelected(String val, NetworkProducts? network) {
    debugPrint("JUST SELECTED NOW::: ${network?.products?.length}");
    debugPrint("JUST SELECTED VALUE::: $val");

    setState(() {
      _amountFixedController?.text = "";
      _productName = widget.service.toLowerCase() == "data"
          ? "Select bundle"
          : "Select package";
      _selectedProduct = null;
      _discountPercent = "0.0000";
    });

    setState(() {
      _networkValue = val;
      _selectedNetwork = network;
    });
    _mproducts = _products(network?.products);

    if (widget.service.toLowerCase() == "airtime" ||
        widget.service.toLowerCase() == "electricity") {
      _controller.percentDiscount.value = network!.discountPercent!;

      double rateVal = double.parse(network.discountPercent!);
      double decimal = (rateVal / 100.0);

      String? amt = _amountController?.text.replaceAll("₦ ", "");
      String filteredAmt = amt!.replaceAll(",", "");

      var reduce = int.parse(amt.replaceAll(",", "")) * decimal;
      _controller.discountAmount.value =
          int.parse(amt.replaceAll(",", "")) - reduce;
    }
  }

  List<MProduct>? _products(List<MProduct>? arr) {
    List<MProduct>? roducts = <MProduct>[];
    roducts = arr;
    return roducts;
  }

  void setSelectedProd(
      int amount, String val, MProduct product, String discount) {
    // _controller.discountAmount.value = 0.0;

    if (discount.isNotEmpty && discount != "null") {
      double percent =
          double.tryParse(discount.contains(".") ? discount : "$discount.0")! /
              100;
      double calc = amount * percent;
      _controller.discountAmount.value = amount - calc;

      debugPrint("DISCOUNT AMT:: $calc");
    } else {
      _controller.discountAmount.value = double.parse("$amount.0");
    }

    setState(() {
      _amountFixedController?.text = "$amount";
      _productName = val;
      _selectedProduct = product;
      _discountPercent = discount == "null" ? "0.0000" : discount;
    });
  }

  @override
  void initState() {
    _initAuth();
    super.initState();
    // debugPrint("PRDUCT DATA: ${widget.product.createdAt}");
    _controller.discountAmount.value = 0.0;
  }

  // _buyTv() async {
  //   _controller.setLoading(true);

  //   // print("SSSASS:: $_discountAmt");

  //   Map _payload = {
  //     "amount": "${_controller.discountAmount.value}", //"$_discountAmt",
  //     "network_id": _selectedNetwork?.id,
  //     "phone": _phoneController.text,
  //     "transaction_type": widget.service.toLowerCase(),
  //     "isn": _smartCardNumController.text,
  //     "product_id": _selectedProduct?.id,
  //   };

  //   try {
  //     final resp = await APIService().transaction(_payload);
  //     debugPrint("${widget.service}:: ${resp.body}");
  //     _controller.setLoading(false);
  //     if (resp.statusCode == 200) {
  //       Map<String, dynamic> map = jsonDecode(resp.body);
  //       TransactionResponse trans = TransactionResponse.fromJson(map);

  //       Constants.toast("${trans.message}");

  //       Navigator.push(
  //         context,
  //         PageTransition(
  //           type: PageTransitionType.rightToLeft,
  //           isIos: true,
  //           child: ConfirmTransaction(
  //             model: trans.data,
  //             isLoggedIn: true,
  //             token: widget.token,
  //           ),
  //         ),
  //       );
  //     } else {
  //       Map<String, dynamic> errorMap = jsonDecode(resp.body);
  //       ErrorResponse error = ErrorResponse.fromJson(errorMap);
  //       Constants.toast("${error.message}");
  //     }
  //   } catch (e) {
  //     _controller.setLoading(false);
  //   }
  // }

  // _buyData() async {
  //   _controller.setLoading(true);

  //   Map _payload = {
  //     "amount": "${_controller.discountAmount.value}", //"$_discountAmt",
  //     "network_id": _selectedNetwork?.id,
  //     "phone": _phoneController.text,
  //     "transaction_type": widget.service.toLowerCase(),
  //     "product_id": _selectedProduct?.id,
  //   };

  //   try {
  //     final resp = await APIService().transaction(_payload);
  //     debugPrint("${widget.service}:: ${resp.body}");
  //     _controller.setLoading(false);
  //     if (resp.statusCode == 200) {
  //       Map<String, dynamic> map = jsonDecode(resp.body);
  //       TransactionResponse trans = TransactionResponse.fromJson(map);

  //       Constants.toast("${trans.message}");

  //       Navigator.push(
  //         context,
  //         PageTransition(
  //           type: PageTransitionType.rightToLeft,
  //           isIos: true,
  //           child: ConfirmTransaction(
  //             model: trans.data,
  //             isLoggedIn: true,
  //             token: widget.token,
  //           ),
  //         ),
  //       );
  //     } else {
  //       Map<String, dynamic> errorMap = jsonDecode(resp.body);
  //       ErrorResponse error = ErrorResponse.fromJson(errorMap);
  //       Constants.toast("${error.message}");
  //     }
  //   } catch (e) {
  //     _controller.setLoading(false);
  //   }
  // }

  // _buyAirtime() async {
  //   _controller.setLoading(true);

  //   String? amt = _amountController?.text.replaceAll("₦ ", "");
  //   String filteredAmt = amt!.replaceAll(",", "");
  //   int price = int.parse(amt.replaceAll(",", ""));

  //   Map _payload = {
  //     "amount": amt.replaceAll(",", ""),
  //     "network_id": _selectedNetwork?.id,
  //     "phone": _phoneController.text,
  //     "transaction_type": widget.service.toLowerCase(),
  //   };

  //   try {
  //     final resp = await APIService().transaction(_payload);
  //     debugPrint("${widget.service}:: ${resp.body}");
  //     _controller.setLoading(false);
  //     if (resp.statusCode == 200) {
  //       Map<String, dynamic> map = jsonDecode(resp.body);
  //       TransactionResponse trans = TransactionResponse.fromJson(map);

  //       Constants.toast("${trans.message}");

  //       Navigator.push(
  //         context,
  //         PageTransition(
  //           type: PageTransitionType.rightToLeft,
  //           isIos: true,
  //           child: ConfirmTransaction(
  //             model: trans.data,
  //             isLoggedIn: true,
  //             token: widget.token,
  //           ),
  //         ),
  //       );
  //     } else {
  //       Map<String, dynamic> errorMap = jsonDecode(resp.body);
  //       ErrorResponse error = ErrorResponse.fromJson(errorMap);
  //       Constants.toast("${error.message}");
  //     }
  //   } catch (e) {
  //     _controller.setLoading(false);
  //   }
  // }

  // _buyElectricity() async {
  //   _controller.setLoading(true);

  //   String? amt = _amountController?.text.replaceAll("₦ ", "");
  //   String filteredAmt = amt!.replaceAll(",", "");
  //   int price = int.parse(amt.replaceAll(",", ""));

  //   Map _payload = {
  //     "amount": amt.replaceAll(",", ""),
  //     "disco_id": _selectedNetwork?.id,
  //     "phone": _phoneController.text,
  //     "transaction_type": widget.service,
  //     "meter_number": _meterNumController.text,
  //     "meter_type": _meterType,
  //   };

  //   try {
  //     final resp = await APIService().transaction(_payload);
  //     debugPrint("${widget.service}:: ${resp.body}");
  //     _controller.setLoading(false);
  //     if (resp.statusCode == 200) {
  //       Map<String, dynamic> map = jsonDecode(resp.body);
  //       TransactionResponse trans = TransactionResponse.fromJson(map);

  //       Constants.toast("${trans.message}");

  //       Navigator.push(
  //         context,
  //         PageTransition(
  //           type: PageTransitionType.rightToLeft,
  //           isIos: true,
  //           child: ConfirmTransaction(
  //             model: trans.data,
  //             isLoggedIn: true,
  //             token: widget.token,
  //           ),
  //         ),
  //       );
  //     } else {
  //       Map<String, dynamic> errorMap = jsonDecode(resp.body);
  //       ErrorResponse error = ErrorResponse.fromJson(errorMap);
  //       Constants.toast("${error.message}");
  //     }
  //   } catch (e) {
  //     _controller.setLoading(false);
  //   }
  // }

  _beginTransaction() async {
    if (_isLoggedIn) {
      //Auth user
      // if (widget.service.toLowerCase() == "airtime") {
      //   _buyAirtime();
      // } else if (widget.service.toLowerCase() == "data") {
      //   _buyData();
      // } else if (widget.service.toLowerCase() == "electricity") {
      //   _buyElectricity();
      // } else {
      //   _buyTv();
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 24,
              ),
              !widget.isAuthenticated
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RoundedInputField(
                          hintText: "Enter your email",
                          icon: const Icon(Icons.email_rounded),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                                    '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          controller: _emailController!,
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10.0,
              ),
              RoundedPhoneField(
                hintText: "Phone",
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp('^(?:[+0]234)?[0-9]{10}').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  if (value.length < 11) {
                    return 'Phone number not valid';
                  }
                  return null;
                },
                inputType: TextInputType.phone,
                controller: _phoneController,
              ),
              const SizedBox(
                height: 10.0,
              ),
              widget.service.toLowerCase() == "electricity"
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        RoundedInputMeterNumber(
                          hintText: "Enter meter number",
                          icon: Icons.numbers,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your meter number';
                            }
                            return null;
                          },
                          controller: _meterNumController,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        RoundedDropdownGender(
                          placeholder: "Select meter type",
                          onSelected: onSelectedMeter,
                          items: const ["Prepaid", "Postpaid"],
                        ),
                      ],
                    )
                  : widget.service.toLowerCase() == "cable_tv"
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            RoundedInputMeterNumber(
                              hintText: "Enter Smartcard/IUC number",
                              icon: Icons.numbers,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your smartcard number';
                                }
                                return null;
                              },
                              controller: _smartCardNumController,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        )
                      : const SizedBox(),
              const SizedBox(
                height: 10.0,
              ),
              RoundedDropdown(
                type: widget.service,
                placeholder: "Select network",
                networks: widget.product?.networks,
                onSelected: setSelected,
                validator: (val) {},
              ),
              const SizedBox(
                height: 10.0,
              ),
              (widget.service.toLowerCase() == "data" ||
                      widget.service.toLowerCase() == "cable_tv")
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextRoboto(
                          text: widget.service.toLowerCase() == "data"
                              ? "Data Bundles"
                              : "Bouquets",
                          color: Constants.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        RoundedDropdownProduct(
                          placeholder: "Select plan",
                          products: _mproducts ?? [],
                          product: _selectedProduct,
                          onSelected: setSelectedProd,
                          value: _productName,
                        ),
                      ],
                    )
                  : const SizedBox(),
              (widget.service.toLowerCase() == "data" ||
                      widget.service.toLowerCase() == "cable_tv")
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextRoboto(
                              text: "Amount",
                              color: Constants.primaryColor,
                              fontSize: 13,
                            ),
                            Text(
                              '${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(_controller.discountAmount.value)}',
                              style: const TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        RoundedInputMoney(
                          hintText: "Enter amount",
                          onChanged: (val) {},
                          enabled: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            return null;
                          },
                          controller: _amountFixedController!,
                        ),
                        TextRoboto(
                          text: _selectedNetwork == null
                              ? ""
                              : "${_discountPercent.length < 3 ? _discountPercent : _discountPercent.substring(0, 4)}% Discount",
                          color: Constants.primaryColor,
                          fontSize: 13,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextRoboto(
                              text: "Amount",
                              color: Constants.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            TextRoboto(
                              text:
                                  '${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(_controller.discountAmount.value)}',
                              color: Constants.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        RoundedInputMoney(
                          hintText: "Enter amount",
                          onChanged: (val) {
                            String? amt = val.replaceAll("₦ ", "");
                            String filteredAmt = amt.replaceAll(",", "");

                            //In real time here
                            if (_networkValue.isNotEmpty) {
                              double rateVal = double.parse(
                                  _selectedNetwork!.discountPercent!);
                              double decimal = (rateVal / 100.0);

                              var reduce =
                                  int.parse(amt.replaceAll(",", "")) * decimal;
                              _controller.discountAmount.value =
                                  int.parse(amt.replaceAll(",", "")) - reduce;
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            return null;
                          },
                          controller: _amountController!,
                        ),
                        TextRoboto(
                          text: _selectedNetwork == null
                              ? ""
                              : "${_selectedNetwork?.discountPercent}% Discount",
                          color: Constants.primaryColor,
                          fontSize: 13,
                        ),
                      ],
                    ),
              const SizedBox(
                height: 16.0,
              ),
              RoundedButton(
                text: "CONTINUE",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _beginTransaction();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
