import 'package:data_extra_app/components/drawer/custom_drawer.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/model/transactions/guest_transaction_model.dart';
import 'package:data_extra_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/card_details.dart';
import 'pay_wallet.dart';
import 'payment_success.dart';

class ConfirmTransaction extends StatefulWidget {
  final GuestTransactionModel model;
  final bool isLoggedIn;
  final String token;
  const ConfirmTransaction({
    Key? key,
    required this.model,
    required this.token,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  State<ConfirmTransaction> createState() => _ConfirmTransactionState();
}

class _ConfirmTransactionState extends State<ConfirmTransaction> {
  final _controller = Get.find<StateController>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final plugin = PaystackPlugin();
  String _paymentMethod = "Card";
  PreferenceManager? _manager;

  void onSelected(String paymentMethod) {
    _paymentMethod = paymentMethod;
  }

  @override
  void initState() {
    super.initState();

    _manager = PreferenceManager(context);
    plugin.initialize(
        publicKey: "pk_test_e4a4319c62eb54ce99d8e4cbde2b46c372c3cb0b");
  }

  _payWallet() async {
    showBarModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: PayWallet(
          manager: _manager!,
          transRef: "${widget.model.transactionRef}",
        ),
      ),
      topControl: ClipOval(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.close,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _payCard() async {
    _controller.setLoading(true);
    final _prefs = await SharedPreferences.getInstance();
    // final _token = _prefs.getString("accessToken") ?? "";

    Charge charge = Charge()
      ..amount = int.parse("${widget.model.amount}") * 100
      ..reference = "${widget.model.transactionRef}"
      ..email = widget.model.email;

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
        // if (_token.isNotEmpty) {
        //   // final userCall = await APIService().getProfile(_token);
        //   debugPrint("USER PROFILE :: ${userCall.body}");
        //   if (userCall.statusCode == 200) {
        //     Map<String, dynamic> _userMap = jsonDecode(userCall.body);

        //     String userData = jsonEncode(_userMap['data']);
        //     _manager?.updateUserData(userData);

        //     Navigator.push(
        //       context,
        //       PageTransition(
        //         type: PageTransitionType.rightToLeft,
        //         isIos: true,
        //         child: PaymentSuccess(manager: _manager!),
        //       ),
        //     );
        //   }
        // } else {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            isIos: true,
            child: PaymentSuccess(manager: _manager!),
          ),
        );
        // }
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
    // final String _token = _prefs.getString("accessToken") ?? "";
    try {
      // final resp = await APIService()
      //     .cancelTransaction(_token, widget.model.transactionRef);
      // debugPrint("CANCEL RESPONSE :: ${resp.body}");
      // toast("Transaction cancelled successfully");

      Future.delayed(const Duration(seconds: 3), () {
        _controller.setLoading(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              manager: _manager,
            ),
          ),
        );
      });
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
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
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
        title: TextPoppins(
          text: "Confirm Transaction".toUpperCase(),
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
          manager: _manager!,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 16.0),
            CardDetailTrans(
              title: "Amount",
              value:
                  "${Constants.nairaSign(context).currencySymbol}${widget.model.amount}",
              icon: Icons.abc_rounded,
            ),
            const SizedBox(height: 16.0),
            CardDetailTrans(
              title: "Email",
              value: widget.model.email,
              icon: Icons.email,
            ),
            "${widget.model.type}".toLowerCase() == "electricity"
                ? Column(
                    children: [
                      const SizedBox(height: 16.0),
                      CardDetailTrans(
                        title: "Meter Number",
                        value: "",
                        icon: Icons.numbers_rounded,
                      ),
                      const SizedBox(height: 16.0),
                      CardDetailTrans(
                        title: "Address",
                        value: "",
                        icon: Icons.location_on,
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 16.0),
            CardDetailTrans(
              title: "Transaction Reference",
              value: "${widget.model.transactionRef}",
              icon: Icons.bubble_chart_rounded,
            ),
            const SizedBox(height: 16.0),
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
                      text: widget.model.description,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            !widget.isLoggedIn
                ? ElevatedButton(
                    onPressed: () => _payCard(),
                    child: const Text("Pay Now"),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextPoppins(
                        text: "Payment Method",
                        color: Constants.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      ElevatedButton(
                        onPressed: () => _payWallet(),
                        child: const Text("Pay Wallet"),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      ElevatedButton(
                        onPressed: () => _payCard(),
                        child: const Text("Pay Card"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
            ElevatedButton(
              onPressed: () => _cancelTransaction(),
              child: TextPoppins(
                text: "Cancel Transaction",
                fontSize: 14,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
