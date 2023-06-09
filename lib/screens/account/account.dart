import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/inputs/rounded_button_wrapped.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/account/components/kyc.dart';
import 'package:airtimeslot_app/screens/account/components/personal_info.dart';
import 'package:airtimeslot_app/screens/account/components/security.dart';
import 'package:airtimeslot_app/screens/welcome/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:page_transition/page_transition.dart';

class Account extends StatelessWidget {
  final PreferenceManager manager;
  Account({Key? key, required this.manager}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.accentColor,
      body: Column(
        children: [
          const SizedBox(height: 56),
          Column(
            children: [
              ClipOval(
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/personal_icon.svg",
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: TextRoboto(
                  text:
                      "${_controller.userData.value['name'] ?? ""}".capitalize,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: TextRoboto(
                  text: "${_controller.userData.value['email'] ?? ""}",
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Center(
                child: RoundedButtonWrapped(
                  text: "Edit Profile",
                  press: () {},
                ),
              )
            ],
          ),
          const SizedBox(height: 16.0),
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
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 2.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextButton(
                            onPressed: () {},
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
                                            "assets/images/user_icon.svg",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextRoboto(
                                          text: "Personal information",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const Text(
                                          "Edit your profile",
                                          style: TextStyle(
                                            color: Colors.grey,
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
                              padding: const EdgeInsets.all(2.0),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
                          TextButton(
                            onPressed: () {},
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
                                          child: SvgPicture.asset(
                                            "assets/images/lock_line_icon.svg",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextRoboto(
                                          text: "Change PIN",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                              padding: const EdgeInsets.all(2.0),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
                          TextButton(
                            onPressed: () {},
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
                                          child: SvgPicture.asset(
                                            "assets/images/passcode_icon.svg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextRoboto(
                                          text: "Change Password",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                              padding: const EdgeInsets.all(2.0),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 21.0,
                          ),
                          TextButton(
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: TextPoppins(
                                    text: "Log Out",
                                    fontSize: 18,
                                  ),
                                  content: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.96,
                                    height: 50,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: const TextSpan(
                                            text: "Are you sure you want to ",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: " log out ",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "? ",
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: TextRoboto(
                                          text: "Cancel",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // _airtimeSwap();
                                          _logout();
                                        },
                                        child: TextRoboto(
                                          text: "Log out",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
                                          child: SvgPicture.asset(
                                            "assets/images/exit_icon.svg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextRoboto(
                                          text: "Log out",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                              padding: const EdgeInsets.all(2.0),
                              foregroundColor: Colors.black,
                            ),
                          )
                        ],
                      ),
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

  _logout() async {
    _controller.setLoading(true);
    try {
      _controller.setLoading(false);
      manager.clearProfile();

      Get.off(const Welcome());

      // if (mounted) {
      // pushNewScreen(
      //   context,
      //   screen: const LogoutLoader(),
      //   withNavBar: false, // OPTIONAL VALUE. True by default.
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );
      // }
    } catch (e) {
      Constants.toast(e.toString());
      _controller.setLoading(false);
    }
  }
}
