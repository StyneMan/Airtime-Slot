import 'dart:convert';

import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/home/home.dart';
import 'package:airtimeslot_app/screens/services/components/card_details.dart';
import 'package:airtimeslot_app/screens/services/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConfirmWalletTrans extends StatefulWidget {
  final PreferenceManager manager;
  var model;
  ConfirmWalletTrans({
    Key? key,
    required this.manager,
    required this.model,
  }) : super(key: key);

  @override
  State<ConfirmWalletTrans> createState() => _ConfirmWalletTransState();
}

class _ConfirmWalletTransState extends State<ConfirmWalletTrans> {
  final _controller = Get.find<StateController>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final plugin = PaystackPlugin();

  @override
  void initState() {
    // plugin.initialize(publicKey: Constants.payKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Constants.primaryColor,
                size: 24,
              ),
            ),
          ],
        ),
        title: TextRoboto(
          text: "Confirm Transaction",
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: Constants.primaryColor,
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
              color: Constants.primaryColor,
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
      body: SafeArea(
        child: SizedBox(
          child: ListView(
          padding: const EdgeInsets.all(16.0),
            children: [
              TextRoboto(
                text:
                    "Hi ${widget.manager.getUser()['name']}, please confirm your transaction to fund your wallet.",
                fontSize: 16,
                align: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              CardDetailTrans(
                title: "Email",
                value: widget.model['email'],
                icon: Icons.email,
              ),
              const SizedBox(height: 10.0),
              CardDetailTrans(
                title: "Amount",
                value: "${widget.model['amount']}",
                icon: Icons.abc_rounded,
              ),
              const SizedBox(height: 10.0),
              CardDetailTrans(
                title: "Transaction Reference",
                value: "${widget.model['transaction_ref']}",
                icon: Icons.bubble_chart_rounded,
              ),
              const SizedBox(height: 10.0),
              Card(
                elevation: 2.0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextPoppins(
                        text: "Description",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Constants.primaryColor,
                      ),
                      TextRoboto(
                        text: "${widget.model['description']}",
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Divider(thickness: 1.5, color: Constants.accentColor),
              const SizedBox(height: 8.0),
              RoundedButton(
                text: "Pay Now",
                press: () {
                  _payCard();
                },
              ),
              const SizedBox(height: 10.0),
              RoundedButton(
                text: "Cancel Transaction",
                press: () {
                  _cancelTransaction();
                },
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }

  _payCard() async {
    _controller.setLoading(true);
    final _prefs = await SharedPreferences.getInstance();
    final _token = _prefs.getString("accessToken") ?? "";

    Charge charge = Charge()
      ..amount = int.parse("${widget.model['amount']}") * 100
      ..reference = widget.model['transaction_ref']
      ..email = widget.model['email'];

    // var accessCode = widget.model.transactionRef;
    // charge.accessCode = accessCode;

    try {
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
        fullscreen: true,
        logo: Image.asset("assets/images/app_logo.png", width: 100),
      );

      debugPrint('Transaction Response => $response');
      debugPrint('Transaction Response Ref => ${response.reference}');
      // _verifyOnServer(response.reference, cart, listMap, user);
      _controller.setLoading(false);

      //Show success screen here
      if (response.message == "Success" || response.verify == true) {
        //Now refresh user data
        if (_token.isNotEmpty) {
          final userCall = await APIService().getProfile(_token);
          debugPrint("USER PROFILE :: ${userCall.body}");
          if (userCall.statusCode == 200) {
            Map<String, dynamic> _userMap = jsonDecode(userCall.body);

            String userData = jsonEncode(_userMap['data']);
            widget.manager.updateUserData(userData);

            await APIService().fetchTransactions(_token);

            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                isIos: true,
                child: PaymentSuccess(manager: widget.manager),
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              isIos: true,
              child: PaymentSuccess(manager: widget.manager),
            ),
          );
        }
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint('Transaction Error Response => $e');
      rethrow;
    }
  }

  _cancelTransaction() async {
    _controller.setLoading(true);
    final _prefs = await SharedPreferences.getInstance();
    final String _token = _prefs.getString("accessToken") ?? "";
    try {
      final resp = await APIService()
          .cancelTransaction(_token, widget.model['transaction_ref']);
      debugPrint("CANCEL RESPONSE :: ${resp.body}");
      Constants.toast("Transaction cancelled successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            manager: widget.manager,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
