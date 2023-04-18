import 'package:easyfit_app/components/text_components.dart';
import 'package:easyfit_app/helper/constants/constants.dart';
import 'package:easyfit_app/screens/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ResetSuccess extends StatelessWidget {
  const ResetSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/success_img.png"),
                const SizedBox(
                  height: 24.0,
                ),
                TextPoppins(
                  text: "Reset Successful",
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        PageTransition(
                          type: PageTransitionType.size,
                          alignment: Alignment.bottomCenter,
                          child: const Login(),
                        ),
                      );
                    },
                    child: TextPoppins(
                      text: "Go to Login",
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Constants.primaryColor,
                      onPrimary: Colors.white,
                      elevation: 0.2,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
