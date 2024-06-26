import 'dart:convert';

import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/error/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardWallet extends StatefulWidget {
  final PreferenceManager manager;
  const CardWallet({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<CardWallet> createState() => _CardWalletState();
}

class _CardWalletState extends State<CardWallet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final TextEditingController _amountController = TextEditingController();

  late Monnify? _monnify;

  _initMonnify() async {
    _monnify = await Monnify.initialize(
      applicationMode: ApplicationMode.LIVE,
      apiKey: Constants.spike,
      contractCode: Constants.contractCode,
    );
  }

  @override
  void initState() {
    super.initState();
    _initMonnify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.accentColor,
      body: Column(
        children: [
          const SizedBox(height: 48),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: TextPoppins(
                  text: "Topup your wallet",
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                left: 8.0,
                top: -5,
                bottom: -5,
                child: Center(
                  child: ClipOval(
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36.0),
          Expanded(
            child: Card(
              color: Colors.white.withOpacity(.9),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextPoppins(
                              text: "Card",
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              height: 24.0,
                            ),
                            TextRoboto(
                              text: "Amount",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: RoundedInputMoney(
                                hintText: "Amount (NGN)",
                                onChanged: (val) {
                                  String? amt = val.replaceAll("₦ ", "");
                                  String filteredAmt = amt.replaceAll(",", "");
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 21.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            width: double.infinity,
                            child: RoundedButton(
                              text: "Continue",
                              press: () {
                                if (_formKey.currentState!.validate()) {
                                  // _initPayment();
                                  _submit();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initPayment(String reference) async {
    String? amt = _amountController.text.replaceAll("₦ ", "");
    String filteredAmt = amt.replaceAll(",", "");

    const rate = 1.4 / 100;
    var total = (rate * double.parse(filteredAmt)) + double.parse(filteredAmt);

    debugPrint("SSFB :: ${total}");

    final transaction = TransactionDetails().copyWith(
      amount: double.parse(filteredAmt) > 2000 ? total += 100 : total,
      currencyCode: 'NGN',
      customerName: widget.manager.getUser()['name'],
      customerEmail: widget.manager.getUser()['email'],
      paymentReference: reference,
      paymentDescription: "Topup wallet",
      // metaData: {"ip": "0.0.0.0", "device": "mobile"},
      paymentMethods: [PaymentMethod.CARD, PaymentMethod.ACCOUNT_TRANSFER],
    );

    try {
      final _response =
          await _monnify?.initializePayment(transaction: transaction);
      debugPrint("Monnify Response:: $_response");
    } on PlatformException catch (e, s) {
      debugPrint("Error initializing payment");
      debugPrint(e.toString());
    }
  }

  _submit() async {
    _controller.setLoading(true);

    String amt = _amountController.text.replaceAll("₦ ", "");

    Map _payload = {
      "amount": amt.replaceAll(",", ""),
      "transaction_type": "fund_wallet",
    };

    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken");
      final resp = await APIService().transactionWallet(_payload, "$_token");

      debugPrint("RESP WALLEEET : ${resp.body}");

      // Use the transaction ref on the monnify sdk
      _controller.setLoading(false);
      if (resp.statusCode == 200) {
        Map<String, dynamic> _respMap = jsonDecode(resp.body);
        _initPayment("${_respMap['data']['transaction_ref']}");
      } else {
        //Error occurred on login
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        ErrorResponse error = ErrorResponse.fromJson(errorMap);
        Constants.toast("${error.message}");
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }
}
