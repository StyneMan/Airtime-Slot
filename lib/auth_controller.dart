import 'package:airtimeslot_app/screens/auth/login/login.dart';
import 'package:airtimeslot_app/screens/auth/login/login2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'logout_loader.dart';

class AuthController extends StatefulWidget {
  final Widget component;
  const AuthController({Key? key, required this.component}) : super(key: key);

  @override
  State<AuthController> createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  bool _isLoggedIn = false;
  Widget _currScreen = Container();

  _initAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('loggedIn') ?? false;

    if (_isLoggedIn) {
      setState(() {
        _currScreen = widget.component;
      });
      Future.delayed(const Duration(milliseconds: 30), () {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.component,),);
        // pushNewScreen(
        //   context,
        //   screen:
        //   withNavBar: true, // OPTIONAL VALUE. True by default.
        //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
        // );
      });
    } else {
      setState(() {
        _currScreen = const Login();
      });

      Future.delayed(const Duration(milliseconds: 50), () {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const Login(),),);
        pushNewScreen(
          context,
          screen: const Login2(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initAuth();
  }

  @override
  Widget build(BuildContext context) {
    return _currScreen;
  }
}
