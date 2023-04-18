import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';
import '../../helper/state/state_manager.dart';
import '../../logout_loader.dart';
import '../../model/drawer/drawermodel.dart';
import '../../screens/account/account.dart';
import '../text_components.dart';

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
  bool _isLoggedIn = true;

  _initAuth() {
    // final prefs = await SharedPreferences.getInstance();
    // _isLoggedIn = prefs.getBool('loggedIn') ?? false;
    // final _user = FirebaseAuth.instance.currentUser;
    setState(() {
      drawerList = [
        DrawerModel(
          icon: 'assets/images/meal_plan_drawer.svg',
          title: 'About Us',
          isAction: false,
          widget: Container(),
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
          icon: 'assets/images/faq_drawer.svg',
          title: 'FAQs',
          isAction: true,
          url: "https://google.com",
        ),
        DrawerModel(
          icon: 'assets/images/contact_drawer.svg',
          title: 'Contact us',
          isAction: true,
          url: "https://google.com",
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
      // await FirebaseAuth.instance.signOut();
      _controller.setLoading(false);

      if (mounted) {
        pushNewScreen(
          context,
          screen: const LogoutLoader(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      }
      // Navigator.of(context).pushReplacement(
      //   PageTransition(
      //     type: PageTransitionType.size,
      //     alignment: Alignment.bottomCenter,
      //     child: const Welcome(),
      //   ),
      // );
    } catch (e) {
      Constants.toast("${e.toString()}");
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
                                  _controller.jumpTo(3);
                                } else {
                                  if (drawerList[i].isAction) {
                                    Navigator.of(context).pop();
                                    _launchInBrowser("${drawerList[i].url}");
                                  } else {
                                    Navigator.of(context).pop();
                                    // pushNewScreen(
                                    //   context,
                                    //   screen: MealPlan(
                                    //     manager: widget.manager,
                                    //   ),
                                    //   withNavBar:
                                    //       false, // OPTIONAL VALUE. True by default.
                                    //   pageTransitionAnimation:
                                    //       PageTransitionAnimation.cupertino,
                                    // );
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
                    _logout();
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
