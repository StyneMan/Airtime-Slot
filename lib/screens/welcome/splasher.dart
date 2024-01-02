import 'package:data_extra_app/components/dialogs/action_dialog.dart';
import 'package:data_extra_app/components/dialogs/fixed_dialog.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Splasher extends StatefulWidget {
  const Splasher({Key? key}) : super(key: key);

  @override
  State<Splasher> createState() => _SplasherState();
}

class _SplasherState extends State<Splasher> {
  final _controller = Get.find<StateController>();

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (_controller.showForcedDialog.value) {
        // Show the forced dialog here
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.98,
                child: FixedDialog(
                  btnText: "Update Now",
                  message:
                      "You are required to update your app to proceed. Click on the button below to update.",
                  action: () {
                    // Now go to url from here
                    _launchInBrowser(_controller.androidAppUrl.value);
                  },
                ));
          },
        );
      }

      if (_controller.showInfoUpdateDialog.value) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.98,
              child: ActionDialog(
                message:
                    "There is a new update available. Click on the button below to update.",
                action: () {
                  // Now go to url from here
                  _launchInBrowser(_controller.androidAppUrl.value);
                },
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(21.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Image.asset(
                      "assets/images/logo_white.png",
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: TextPoppins(
                        text:
                            "The easiest way to buy Internet data, Airtime top-ups, cable TV subscriptions and Electricity.",
                        fontSize: 14,
                        align: TextAlign.center,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 21.0,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 12,
              right: 12,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(
                    const Welcome(),
                    transition: Transition.cupertino,
                  );
                },
                child: TextPoppins(
                  text: "Continue",
                  fontSize: 16,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.white,
                  foregroundColor: Constants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
