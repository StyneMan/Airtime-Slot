import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatefulWidget {
  final PreferenceManager? manager;
  const Support({
    Key? key,
    this.manager,
  }) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final _searchController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _refreshController = RefreshController(initialRefresh: false);

  var _filtered = [];
  bool _isLoaded = false, isSpinning = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  Future<void>? _launched;
  var emailLaunchUri;

  _makePhoneCall(String phoneNumber) {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    canLaunch('tel:123').then((bool result) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launch(launchUri.toString());
    });
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  void initState() {
    super.initState();
    emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@airtimeslot.com',
      query:
          encodeQueryParameters(<String, String>{'subject': 'Contact Support'}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.accentColor,
      body: Column(
        children: [
          const SizedBox(height: 48),
          Stack(
            children: [
              Center(
                child: TextRoboto(
                  text: "Help center",
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              Text(
                                "Tell us how we can help",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Our crew are standing by for \nservice and support",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextButton(
                          onPressed: () {
                            _makePhoneCall("09045852364");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Constants.primaryColor,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/images/phone_call_icon.svg",
                                          width: 21,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextRoboto(
                                        text: "Call us",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Text(
                                        "Quick response over the phone",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 21.0,
                        ),
                        TextButton(
                          onPressed: () {
                            launch(emailLaunchUri.toString());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Constants.primaryColor,
                                      padding: const EdgeInsets.all(8.0),
                                      width: 36,
                                      height: 36,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/bill_icon.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextRoboto(
                                        text: "Email",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Text(
                                        "Get a solution beamed to your inbox",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            foregroundColor: Colors.black,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 21.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
