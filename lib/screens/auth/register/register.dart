import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/forms/signup/signupform.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/screens/auth/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class Register extends StatefulWidget {
  const Register({
    Key? key,
  }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _controller = Get.find<StateController>();
  PreferenceManager? _manager;

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
    _manager = PreferenceManager(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        backgroundColor: Colors.black54,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        child: Scaffold(
          backgroundColor: Constants.accentColor,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Image.asset("assets/images/cta_image.png"),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextPoppins(
                            text: "Data Extra",
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            align: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Text(
                            "The easiest way to make your online payments for Internet, Data, Airtime, Cable TV",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 10,
                child: SlidingUpPanel(
                  maxHeight: MediaQuery.of(context).size.height * 0.72,
                  minHeight: MediaQuery.of(context).size.height * 0.72,
                  parallaxEnabled: true,
                  defaultPanelState: PanelState.OPEN,
                  renderPanelSheet: true,
                  parallaxOffset: .5,
                  body: Container(
                    color: Constants.accentColor.withOpacity(0.5),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  panelBuilder: (sc) => _panel(sc),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(56.0),
                    topRight: Radius.circular(56.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              const Text(
                "Create an account to get started",
              ),
              const SizedBox(
                height: 24.0,
              ),
              SignupForm(
                manager: _manager!,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(
                    width: 16.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(const Login(), transition: Transition.downToUp);
                    },
                    child: const Text("Log in"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
