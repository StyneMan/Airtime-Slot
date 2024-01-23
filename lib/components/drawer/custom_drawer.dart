import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:data_extra_app/model/drawer/drawermodel.dart';
import 'package:data_extra_app/screens/account/account.dart';
import 'package:data_extra_app/screens/auth/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  final PreferenceManager manager;
  const CustomDrawer({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<DrawerModel> drawerList = [];

  final _controller = Get.find<StateController>();

  _initAuth() {
    setState(() {
      drawerList = [
        DrawerModel(
          icon: 'assets/images/meal_plan_drawer.svg',
          title: 'Website',
          isAction: true,
          url: "https://www.dataextra.ng/",
        ),
        DrawerModel(
          icon: 'assets/images/maccount_drawer.svg',
          title: 'My Account',
          isAction: false,
          widget: Account(
            manager: widget.manager,
          ),
        ),
        DrawerModel(
          icon: 'assets/images/contact_drawer.svg',
          title: 'Contact us',
          isAction: true,
          url: "https://www.dataextra.ng/contact",
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  _logout() async {
    _controller.setLoading(true);
    try {
      await APIService().logout(
        widget.manager.getAccessToken(),
      );
      _controller.setLoading(false);
      widget.manager.clearProfile();
      widget.manager.clearEmail();
      _controller.resetAll();
      Get.offAll(const Login());

      // if (mounted) {
      //   // pushNewScreen(
      //   //   context,
      //   //   screen: const LogoutLoader(),
      //   //   withNavBar: false, // OPTIONAL VALUE. True by default.
      //   //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      //   // );
      // }
    } catch (e) {
      Constants.toast(e.toString());
      _controller.setLoading(false);
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.33),
      child: Container(
        color: Colors.white,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 32.0, left: 24, right: 24, bottom: 1),
                    width: double.infinity,
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.164,
                    child: Center(
                      child: TextPoppins(
                        text: "Menu",
                        fontSize: 18,
                        color: Colors.black,
                        align: TextAlign.center,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return ListTile(
                              dense: true,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  drawerList[i].title == "How It Works"
                                      ? Icon(
                                          drawerList[i].icon,
                                          color: Constants.primaryColor,
                                        )
                                      : SvgPicture.asset(
                                          drawerList[i].icon,
                                          width: 22,
                                          color: Constants.primaryColor,
                                        ),
                                  const SizedBox(
                                    width: 21.0,
                                  ),
                                  TextPoppins(
                                    text: drawerList[i].title,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF272121),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (i == 1) {
                                  Navigator.of(context).pop();
                                  _controller.tabController.jumpToTab(3);
                                } else {
                                  if (drawerList[i].isAction) {
                                    Navigator.of(context).pop();
                                    _launchInBrowser("${drawerList[i].url}");
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: drawerList.length,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width * 0.45,
              child: Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: TextPoppins(
                          text: "Log Out",
                          fontSize: 18,
                        ),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.96,
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
                    // _logout();
                  },
                  label: TextPoppins(
                    text: "Log Out",
                    fontSize: 14,
                    align: TextAlign.center,
                    color: Colors.black,
                  ),
                  icon: const Icon(CupertinoIcons.power),
                ),
              ),
            ),
            const SizedBox(
              height: 21,
            ),
          ],
        ),
      ),
    );
  }
}
