import 'package:data_extra_app/components/inputs/rounded_button_wrapped.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/screens/account/components/personal_info.dart';
import 'package:data_extra_app/screens/account/components/security.dart';
import 'package:data_extra_app/screens/auth/login/login.dart';
import 'package:data_extra_app/screens/welcome/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import 'components/kyc.dart';

class Account extends StatelessWidget {
  final PreferenceManager manager;
  Account({Key? key, required this.manager}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        backgroundColor: Colors.black54,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        child: Scaffold(
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
                      text: "${_controller.userData.value['name'] ?? ""}"
                          .capitalize,
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
                      press: () {
                        Get.to(
                          PersonalInfo(
                            manager: manager,
                            shouldEdit: true,
                          ),
                          transition: Transition.cupertino,
                        );
                      },
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
                                onPressed: () {
                                  Get.to(
                                    PersonalInfo(
                                      manager: manager,
                                      shouldEdit: true,
                                    ),
                                    transition: Transition.cupertino,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              text: "Personal Information",
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
                                onPressed: () {
                                  Get.to(
                                    KYC(
                                      manager: manager,
                                    ),
                                    transition: Transition.cupertino,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            color: Constants.primaryColor,
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Center(
                                              child: Icon(
                                                CupertinoIcons
                                                    .person_crop_circle_badge_checkmark,
                                                color: Colors.white,
                                                size: 21,
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
                                              text: "Know Your Customer",
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            const Text(
                                              "Setup your KYC",
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
                                onPressed: () {
                                  _controller.tabController.jumpToTab(2);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            color: Constants.primaryColor,
                                            padding: const EdgeInsets.all(8.0),
                                            width: 36,
                                            height: 36,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/images/headphone_icon.svg",
                                                  color: Colors.white),
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
                                              text: "Help Center",
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
                                  Get.to(
                                    Security(
                                      manager: manager,
                                    ),
                                    transition: Transition.cupertino,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                text:
                                                    "Are you sure you want to ",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
        ),
      ),
    );
  }

  _logout() async {
    _controller.setLoading(true);
    try {
      await APIService().logout(manager.getAccessToken());
      _controller.setLoading(false);
      manager.clearProfile();
      manager.clearEmail();
      _controller.resetAll();

      Get.off(const Login());
    } catch (e) {
      Constants.toast(e.toString());
      _controller.setLoading(false);
    }
  }
}
