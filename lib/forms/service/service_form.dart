import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/text_components.dart';
import '../../data/products/products.dart';
import '../../data/transactions/demo_transactions.dart';
import '../../helper/constants/constants.dart';
import '../../helper/state/state_manager.dart';
import '../../screens/services/confirm_transaction.dart';

class ServiceForm extends StatefulWidget {
  final bool isAuthenticated;
  final String service;
  final String token;
  final Product? product;
  final String? mAmount;

  const ServiceForm({
    Key? key,
    this.mAmount,
    required this.token,
    required this.service,
    required this.product,
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
  Network? _selectedNetwork;
  Packages? _selectedPackage;
  double _discountAmt = 0.0;
  String _discountPercent = "";
  bool _isLoggedIn = false;
  List<Packages>? _mproducts = [];
  final _controller = Get.find<StateController>();

  String _meterType = "Prepaid";

  void onSelectedMeter(String type) {
    setState(() {
      _meterType = type;
    });
  }

  // _initAuth() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     _isLoggedIn = prefs.getBool('loggedIn') ?? false;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  void setSelected(String val, Network? network) {
    debugPrint("JUST SELECTED NOW::: ${network?.packages?.length}");
    debugPrint("JUST SELECTED VALUE::: $val");

    setState(() {
      _networkValue = val;
      _selectedNetwork = network;
    });
    // _mproducts = _products(network?.packages);
    // _updateProductList(network);
    // _computeDiscount(network);
  }

  List<dynamic>? _products(List<dynamic>? arr) {
    List<dynamic>? roducts = <dynamic>[];
    roducts = arr;
    return roducts;
  }

  void setSelectedProd(
      int amount, String val, dynamic product, String discount) {
    // if (discount.isNotEmpty) {
    //   double percent = double.parse(discount) / 100;
    //   double calc = amount * percent;
    //   setState(() => _discountAmt = amount - calc);

    //   debugPrint("DISCOUNT AMT:: $calc");
    // } else {
    //   setState(() => _discountAmt = double.parse("$amount.0"));
    // }
    setState(() {
      _amountFixedController?.text = "$amount";
      _productName = val;
      // _selectedProduct = product;
      _discountPercent = discount;
    });
  }

  // void _computeDiscount(NetworkProducts? network) {
  //   double discountPercent =
  //       (double.parse("${network?.discountPercent}") / 100);
  //   double mantissa =
  //       discountPercent * double.parse("${_amountController?.text}");

  //   setState(() {
  //     _discountAmt = double.parse("${_amountController?.text}") - mantissa;
  //   });
  // }

  @override
  void initState() {
    // _initAuth();
    super.initState();
    // debugPrint("PRDUCT DATA: ${widget.product.createdAt}");
  }

  _buyTv() async {
    _controller.setLoading(true);

    // Map _payload = {
    //   "amount": "$_discountAmt",
    //   "network_id": _selectedNetwork?.,
    //   "phone": _phoneController.text,
    //   "transaction_type": widget.service.toLowerCase(),
    //   "isn": _smartCardNumController.text,
    //   "product_id": _selectedProduct?.id,
    // };

    try {
      // final resp = await APIService().transaction(_payload);
      // debugPrint("${widget.service}:: ${resp.body}");
      // _controller.setLoading(false);
      // if (resp.statusCode == 200) {
      //   Map<String, dynamic> map = jsonDecode(resp.body);
      //   TransactionResponse trans = TransactionResponse.fromJson(map);

      //   toast("${trans.message}");

      Future.delayed(const Duration(seconds: 3), () {
        _controller.setLoading(false);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            isIos: true,
            child: ConfirmTransaction(
              model: recentTransactions.elementAt(0),
              isLoggedIn: false,
              token: widget.token,
            ),
          ),
        );
      });
      // } else {
      //   Map<String, dynamic> errorMap = jsonDecode(resp.body);
      //   ErrorResponse error = ErrorResponse.fromJson(errorMap);
      //   toast("${error.message}");
      // }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  _buyData() async {
    _controller.setLoading(true);

    // Map _payload = {
    //   "amount": "$_discountAmt",
    //   "network_id": _selectedNetwork?.id,
    //   "phone": _phoneController.text,
    //   "transaction_type": widget.service.toLowerCase(),
    //   "product_id": _selectedProduct?.id,
    // };

    try {
      // final resp = await APIService().transaction(_payload);
      // debugPrint("${widget.service}:: ${resp.body}");
      // _controller.setLoading(false);
      // if (resp.statusCode == 200) {
      //   Map<String, dynamic> map = jsonDecode(resp.body);
      //   TransactionResponse trans = TransactionResponse.fromJson(map);

      //   toast("${trans.message}");

      Future.delayed(const Duration(seconds: 3), () {
        _controller.setLoading(false);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            isIos: true,
            child: ConfirmTransaction(
              model: recentTransactions.elementAt(0),
              isLoggedIn: false,
              token: widget.token,
            ),
          ),
        );
      });
      // } else {
      //   Map<String, dynamic> errorMap = jsonDecode(resp.body);
      //   ErrorResponse error = ErrorResponse.fromJson(errorMap);
      //   toast("${error.message}");
      // }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  _buyAirtime() async {
    _controller.setLoading(true);

    String? amt = _amountController?.text.replaceAll("₦ ", "");
    String filteredAmt = amt!.replaceAll(",", "");
    int price = int.parse(amt.replaceAll(",", ""));

    // Map _payload = {
    //   "amount": amt.replaceAll(",", ""),
    //   "network_id": _selectedNetwork?.id,
    //   "phone": _phoneController.text,
    //   "transaction_type": widget.service.toLowerCase(),
    // };

    try {
      // final resp = await APIService().transaction(_payload);
      // debugPrint("${widget.service}:: ${resp.body}");
      // _controller.setLoading(false);
      // if (resp.statusCode == 200) {
      //   Map<String, dynamic> map = jsonDecode(resp.body);
      //   TransactionResponse trans = TransactionResponse.fromJson(map);

      //   toast("${trans.message}");

      Future.delayed(const Duration(seconds: 3), () {
        _controller.setLoading(false);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            isIos: true,
            child: ConfirmTransaction(
              model: recentTransactions.elementAt(0),
              isLoggedIn: false,
              token: widget.token,
            ),
          ),
        );
      });
      // } else {
      //   Map<String, dynamic> errorMap = jsonDecode(resp.body);
      //   ErrorResponse error = ErrorResponse.fromJson(errorMap);
      //   toast("${error.message}");
      // }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  _buyElectricity() async {
    _controller.setLoading(true);

    String? amt = _amountController?.text.replaceAll("₦ ", "");
    String filteredAmt = amt!.replaceAll(",", "");
    int price = int.parse(amt.replaceAll(",", ""));

    // Map _payload = {
    //   "amount": amt.replaceAll(",", ""),
    //   "disco_id": _selectedNetwork?.id,
    //   "phone": _phoneController.text,
    //   "transaction_type": widget.service,
    //   "meter_number": _meterNumController.text,
    //   "meter_type": _meterType,
    // };

    try {
      // final resp = await APIService().transaction(_payload);
      // debugPrint("${widget.service}:: ${resp.body}");
      // _controller.setLoading(false);
      // if (resp.statusCode == 200) {
      //   Map<String, dynamic> map = jsonDecode(resp.body);
      //   TransactionResponse trans = TransactionResponse.fromJson(map);

      //   toast("${trans.message}");

      Future.delayed(const Duration(seconds: 3), () {
        _controller.setLoading(false);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            isIos: true,
            child: ConfirmTransaction(
              model: recentTransactions.elementAt(0),
              isLoggedIn: false,
              token: widget.token,
            ),
          ),
        );
      });
      // } else {
      //   Map<String, dynamic> errorMap = jsonDecode(resp.body);
      //   ErrorResponse error = ErrorResponse.fromJson(errorMap);
      //   toast("${error.message}");
      // }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  _beginTransaction() async {
    // if (_isLoggedIn) {
    //Auth user
    if (widget.service.toLowerCase() == "airtime") {
      _buyAirtime();
    } else if (widget.service.toLowerCase() == "data") {
      _buyData();
    } else if (widget.service.toLowerCase() == "electricity") {
      _buyElectricity();
    } else {
      _buyTv();
    }
    // } else {
    //   //Guest user
    //   if (widget.service.toLowerCase() == "airtime") {
    //     _guestPayAirtime();
    //   } else if (widget.service.toLowerCase() == "data") {
    //     _guestPayData();
    //   } else if (widget.service.toLowerCase() == "electricity") {
    //     _guestPayElectricity();
    //   } else {
    //     _guestPayTv();
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          !widget.isAuthenticated
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextPoppins(
                      text: "Email Address",
                      color: Constants.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    TextFormField(
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            gapPadding: 1.0,
                          ),
                          filled: false,
                          labelText: 'Email',
                          hintText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            gapPadding: 1.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            gapPadding: 1.0,
                          ),
                          prefixIcon: Icon(Icons.email_outlined)),
                      controller: _emailController!,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(
            height: 16,
          ),
          TextPoppins(
            text: "Phone Number",
            color: Constants.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              filled: false,
              labelText: 'Phone Number',
              hintText: 'Phone number',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              prefixIcon: Icon(Icons.phone),
            ),
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp('^(?:[+0]234)?[0-9]{10}').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              if (value.length < 10) {
                return 'Phone number not valid';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
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
                    TextPoppins(
                      text: "Meter Number",
                      color: Constants.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    TextFormField(
                      cursorColor: Constants.primaryColor,
                      enabled: true,
                      inputFormatters: <TextInputFormatter>[
                        MaskTextInputFormatter(
                          mask: '#### #### #### #### #### ####',
                          filter: {"#": RegExp(r'[0-9]')},
                          type: MaskAutoCompletionType.lazy,
                        )
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                        filled: false,
                        prefixIcon: Icon(
                          Icons.numbers_outlined,
                          color: Constants.primaryColor,
                        ),
                        hintText: "Enter meter number",
                        labelText: "Meter Number",
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                      ),
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
                      height: 16.0,
                    ),
                    TextPoppins(
                      text: "Meter Type",
                      color: Constants.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12.0, right: 2.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Constants.primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: DropdownButton(
                        hint: const Text("Select meter type"),
                        items: ["Prepaid", "Postpaid"].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        // value: _meterType,
                        onChanged: (newValue) async {
                          setState(
                            () {
                              _meterType = "$newValue";
                            },
                          );
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 30,
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                )
              : widget.service.toLowerCase() == "cable tv"
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextPoppins(
                          text: "Smartcard/IUC No",
                          color: Constants.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        TextFormField(
                          cursorColor: Constants.primaryColor,
                          enabled: true,
                          inputFormatters: <TextInputFormatter>[
                            MaskTextInputFormatter(
                              mask: '#### #### #### #### #### ####',
                              filter: {"#": RegExp(r'[0-9]')},
                              type: MaskAutoCompletionType.lazy,
                            )
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              gapPadding: 1.0,
                            ),
                            filled: false,
                            prefixIcon: Icon(
                              Icons.numbers_outlined,
                              color: Constants.primaryColor,
                            ),
                            hintText: "Enter Smartcard/IUC number",
                            labelText: "Enter Smartcard/IUC number",
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              gapPadding: 1.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              gapPadding: 1.0,
                            ),
                          ),
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
            height: 16.0,
          ),
          TextPoppins(
            text: "Network",
            color: Constants.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12.0, right: 2.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Constants.primaryColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: DropdownButton(
              hint: const Text("Select network"),
              items: widget.product?.networks?.map((e) {
                return DropdownMenuItem(
                  value: e.name,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        e.icon,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) => Image.asset(
                          "assets/images/placeholder.png",
                          width: 32,
                          height: 32,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      TextPoppins(
                        text: e.name,
                        fontSize: 14,
                      ),
                    ],
                  ),
                );
              }).toList(),
              // value: _networkValue,
              onChanged: (newValue) {
                var _currNetwork = widget.product?.networks!
                    .firstWhere((element) => element.name == newValue);

                setState(
                  () {
                    _networkValue = "$newValue";
                  },
                );

                setSelected("$newValue", _currNetwork);
                // widget.onSelected(
                //   newValue as String,
                //   widget.networks!
                //       .firstWhere((element) => element.name == newValue),
                // );
              },
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              iconSize: 30,
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          (widget.service.toLowerCase() == "data" ||
                  widget.service.toLowerCase() == "cable tv")
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextPoppins(
                      text: widget.service.toLowerCase() == "data"
                          ? "Data Bundles"
                          : "Bouquets",
                      color: Constants.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12.0, right: 2.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Constants.primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: DropdownButton(
                        hint: Text(_selectedPackage?.name ?? "Select product"),
                        items: widget.product?.networks?.map((e) {
                          return DropdownMenuItem(
                            value: e.name,
                            child: Text(e.name),
                          );
                        }).toList(),
                        onChanged: (newValue) async {
                          if (_selectedNetwork != null) {
                            var prod = _selectedNetwork?.packages?.firstWhere(
                                (element) => element.name == newValue);
                            setSelectedProd(prod!.amount, prod.name, prod, "");
                            // debugPrint("SDS::: ${prod.discountPercent}");
                            // widget.onSelected(prod.amount!, newValue as String,
                            //     prod, "${prod.discountPercent}");
                            // setState(
                            //   () {
                            //     // _modelValue = prod.name;
                            //   },
                            // );
                          }
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 30,
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(
            height: 12.0,
          ),
          (widget.service.toLowerCase() == "data" ||
                  widget.service.toLowerCase() == "cable_tv")
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextPoppins(
                          text: "Amount",
                          color: Constants.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        // Text(
                        //   '${Constants.nairaSign(context).currencySymbol} ${Constants.formatMoneyFloat(1021.23)}',
                        //   style: const TextStyle(
                        //     color: Constants.primaryColor,
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                    TextFormField(
                      onChanged: (val) {},
                      cursorColor: Constants.primaryColor,
                      controller: _amountFixedController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                      enabled: false,
                      inputFormatters: <TextInputFormatter>[
                        CurrencyTextInputFormatter(
                          locale: 'en',
                          decimalDigits: 0,
                          symbol: '₦ ',
                        ),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                        filled: false,
                        prefixIcon: Icon(
                          CupertinoIcons.money_dollar_circle_fill,
                          color: Constants.primaryColor,
                        ),
                        hintText: "Enter amount",
                        labelText: 'Amount',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                      ),
                    ),
                    TextPoppins(
                      text: _selectedNetwork == null
                          ? ""
                          : "-${_discountPercent.length < 3 ? _discountPercent : _discountPercent.substring(0, 4)}% Discount",
                      color: Constants.primaryColor,
                      fontSize: 13,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextPoppins(
                          text: "Amount",
                          color: Constants.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        TextPoppins(
                          text:
                              '${Constants.nairaSign(context).currencySymbol} ${Constants.formatMoneyFloat(123.021)}',
                          color: Constants.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    TextFormField(
                      onChanged: (val) {},
                      cursorColor: Constants.primaryColor,
                      controller: _amountController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                      enabled: true,
                      inputFormatters: <TextInputFormatter>[
                        CurrencyTextInputFormatter(
                          locale: 'en',
                          decimalDigits: 0,
                          symbol: '₦ ',
                        ),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                        filled: false,
                        prefixIcon: Icon(
                          CupertinoIcons.money_dollar_circle_fill,
                          color: Constants.primaryColor,
                        ),
                        hintText: "Enter amount",
                        labelText: 'Amount',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 1.0,
                        ),
                      ),
                    ),
                    TextPoppins(
                      text: _selectedNetwork == null ? "" : "-${1.0}% Discount",
                      color: Constants.primaryColor,
                      fontSize: 13,
                    ),
                  ],
                ),
          const SizedBox(
            height: 16.0,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _beginTransaction();
                }
              },
              child: TextPoppins(
                text: "Continue",
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
