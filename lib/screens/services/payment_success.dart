import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/text_components.dart';
import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';
import '../home/home.dart';

class PaymentSuccess extends StatelessWidget {
  final PreferenceManager manager;
  const PaymentSuccess({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/payment_success.svg"),
            const SizedBox(
              height: 10.0,
            ),
            TextPoppins(
              text: "Payment Successful",
              fontSize: 20,
              color: Constants.primaryColor,
              align: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      isIos: true,
                      child: Home(
                        manager: manager,
                      ),
                    ),
                  );
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
      ),
    );
  }
}
