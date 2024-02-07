import 'package:airtimeslot_app/components/dialogs/action_dialog.dart';
import 'package:airtimeslot_app/components/dialogs/fixed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helper/state/state_controller.dart';

class TriggerController extends StatefulWidget {
  final Widget child;
  const TriggerController({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<TriggerController> createState() => _TriggerControllerState();
}

class _TriggerControllerState extends State<TriggerController> {
  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(const Duration(seconds: 3), () {
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
                ),
              );
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
  }

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
  Widget build(BuildContext context) {
    return widget.child;
  }
}
