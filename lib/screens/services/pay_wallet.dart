import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../components/text_components.dart';
import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';
import '../../helper/state/state_manager.dart';

class PayWallet extends StatefulWidget {
  final PreferenceManager manager;
  final String transRef;
  const PayWallet({
    Key? key,
    required this.manager,
    required this.transRef,
  }) : super(key: key);

  @override
  State<PayWallet> createState() => _PayWalletState();
}

class _PayWalletState extends State<PayWallet> {
  final _otpController = OtpFieldController();
  final _controller = Get.find<StateController>();

  _loginWallet() async {
    _controller.setLoading(true);
    Map _payload = {
      "method": "wallet",
      "transaction_ref": widget.transRef,
      "wallet_pin": _otpController.toString()
    };
    try {
      // final resp =
      //     await APIService().payment(_payload, widget.manager.getAccessToken());
      // debugPrint("WALLET PAYMENT RESP>> ${resp.body}");
      _controller.setLoading(false);
    } catch (e) {
      debugPrint(e.toString());
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextPoppins(
            text: "Pay With Wallet",
            fontSize: 18,
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextPoppins(
            text: "Wallet Balance",
            fontSize: 14,
            align: TextAlign.center,
          ),
          Text(
            "${Constants.nairaSign(context).currencySymbol}1,000,000",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Constants.primaryColor,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextPoppins(
            text:
                "Enter your wallet PIN to proceed. You are advised not disclose your PIN to anybody for security reasons.",
            fontSize: 14,
            align: TextAlign.center,
          ),
          const SizedBox(
            height: 10.0,
          ),
          OTPTextField(
            length: 4,
            width: MediaQuery.of(context).size.width * 0.75,
            fieldWidth: 100,
            contentPadding: const EdgeInsets.all(8.0),
            style: const TextStyle(
              fontSize: 17,
              color: Constants.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            controller: _otpController,
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.box,
            onCompleted: (pin) {
              print("Completed: " + pin);
            },
            spaceBetween: 4.0,
            keyboardType: TextInputType.number,
            obscureText: true,
            outlineBorderRadius: 1.5,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () => _loginWallet(),
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
