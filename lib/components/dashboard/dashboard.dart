import 'dart:convert';
import 'dart:io';

import 'package:airtimeslot_app/components/dialogs/announcement_dialog.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/connectivity/net_conectivity.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/service/api_service.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/account/account.dart';
import 'package:airtimeslot_app/screens/home/home.dart';
import 'package:airtimeslot_app/screens/network/no_internet.dart';
import 'package:airtimeslot_app/screens/support/support.dart';
import 'package:airtimeslot_app/screens/pay/pay.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  final PreferenceManager manager;
  Dashboard({Key? key, required this.manager}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoggedIn = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  int indx = 0;

  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';

  _init() async {
    if (_controller.transactions.value.isEmpty) {
      try {
        final _prefs = await SharedPreferences.getInstance();
        final _token = _prefs.getString("accessToken") ?? "";
        // final _reloadedApp = _prefs.getBool("isReloadedApp") ?? false;

        if (_token.isNotEmpty) {
          APIService().fetchTransactions(_token);
        }

        // Show Announcement here
        final _resp = await APIService().announcement(accessToken: _token);
        print("Announcement Data: ${_resp.body}");

        if (_resp.statusCode == 200) {
          Map<String, dynamic> _map = jsonDecode(_resp.body);

          if (_map['data']?.length > 0) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return SizedBox(
                  height: 360,
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: AnnouncementDialog(
                    title: "General Announcement",
                    content: SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(2.0),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  _map['data'][index]['value'] == null
                                      ? const SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.circle,
                                              size: 13,
                                              color: Constants.primaryColor,
                                            ),
                                            const SizedBox(width: 10.0),
                                            Expanded(
                                              child: TextPoppins(
                                                text:
                                                    "${_map['data'][index]['value']}",
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                              separatorBuilder: (context, index) {
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4.0),
                                    Divider(),
                                    SizedBox(height: 4.0),
                                  ],
                                );
                              },
                              itemCount: _map['data']?.length,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }

        // if (!_reloadedApp) {
        //   _prefs.setBool("isReloadedApp", true);
        //   // Restart.restartApp();
        // }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _init();

    _networkConnectivity.initialize();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      debugPrint('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
          _controller.hasInternetAccess.value = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();

    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= const Duration(seconds: 4);
        pre_backpress = DateTime.now();
        if (cantExit) {
          Fluttertoast.showToast(
            msg: "Press again to exit",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
            fontSize: 16.0,
          );

          return false; // false will do nothing when back press
        } else {
          // _controller.triggerAppExit(true);
          if (Platform.isAndroid) {
            // Log user out here
            final _prefs = await SharedPreferences.getInstance();
            final _token = _prefs.getString('accessToken') ?? "";

            await _prefs.remove("user");
            await _prefs.remove("loggedIn");
            await _prefs.remove("accessToken");

            await APIService().logout(_token);

            _controller.resetAll();

            exit(0);
          } else if (Platform.isIOS) {}
          return true;
        }
      },
      child: Obx(
        () => LoadingOverlayPro(
          isLoading: _controller.isLoading.value,
          progressIndicator: Platform.isAndroid
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const CupertinoActivityIndicator(
                  animating: true,
                ),
          backgroundColor: Colors.black54,
          child: !_controller.hasInternetAccess.value
              ? const NoInternet()
              : Scaffold(
                  backgroundColor: Constants.backgroundColor,
                  key: _scaffoldKey,
                  body: _controller.hideNavbar.value
                      ? const SizedBox()
                      : PersistentTabView(
                          context,
                          screens: _buildScreens(_isLoggedIn),
                          items: _navBarsItems(),
                          backgroundColor: Colors.white,
                          controller: _controller.tabController,
                          confineToSafeArea: true,
                          navBarHeight: 64,
                          handleAndroidBackButtonPress:
                              false, // Default is true.
                          resizeToAvoidBottomInset:
                              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                          stateManagement: true, // Default is true.
                          hideNavigationBarWhenKeyboardAppears:
                              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                          decoration: const NavBarDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            colorBehindNavBar: Colors.white,
                          ),
                          onItemSelected: (val) {
                            setState(() {
                              indx = val;
                            });
                          },
                          popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
                          animationSettings: const NavBarAnimationSettings(
                            navBarItemAnimation: ItemAnimationSettings(
                              duration: Duration(
                                milliseconds: 200,
                              ),
                              curve: Curves.ease,
                            ),
                            screenTransitionAnimation:
                                ScreenTransitionAnimationSettings(
                              animateTabTransition: true,
                              curve: Curves.ease,
                              duration: Duration(
                                milliseconds: 200,
                              ),
                            ),
                          ),
                          navBarStyle: NavBarStyle
                              .style6, // Choose the nav bar style with this property.
                        ),
                ),
        ),
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home_rounded,
          size: 24,
        ),
        title: "Home",
        activeColorPrimary: Constants.primaryColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.grey,
        activeColorSecondary: Constants.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.paperplane),
        title: "Pay",
        activeColorPrimary: Constants.primaryColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.grey,
        activeColorSecondary: Constants.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          "assets/images/headset_icon.svg",
          color: indx == 2 ? Constants.primaryColor : Colors.grey,
        ),
        title: "Support",
        activeColorPrimary: Constants.primaryColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.grey,
        activeColorSecondary: Constants.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          CupertinoIcons.person,
          size: 24,
        ),
        title: ("Account"),
        activeColorPrimary: Constants.primaryColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.grey,
        activeColorSecondary: Constants.primaryColor,
      ),
    ];
  }

  List<Widget> _buildScreens(_loggedIn) {
    return [
      Home(
        manager: widget.manager,
      ),
      Pay(
        manager: widget.manager,
      ),
      Support(manager: widget.manager),
      Account(manager: widget.manager)
    ];
  }
}
