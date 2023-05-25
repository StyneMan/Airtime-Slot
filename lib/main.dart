// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:airtimeslot_app/helper/theme/app_theme.dart';
import 'package:airtimeslot_app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/dashboard/dashboard.dart';
import 'helper/constants/constants.dart';
import 'helper/preferences/preference_manager.dart';
import 'helper/state/state_controller.dart';
import 'screens/network/no_internet.dart';
import 'screens/onboarding/walkthrough.dart';

enum Version { lazy, wait }

const String version = String.fromEnvironment('VERSION');
const Version running = version == "lazy" ? Version.lazy : Version.wait;

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StateController>(() => StateController(), fenix: true);
  }
}

/// Calling [await] dependencies(), your app will wait until dependencies are loaded.
class AwaitBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<StateController>(() async {
      Dao _dao = await Dao.createAsync();
      return StateController(myDao: _dao);
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = Get.put(StateController());
  Widget? component;
  PreferenceManager? _manager;

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splash(
                controller: _controller,
              ));
        } else {
          // Loading is done, return the app:
          final SharedPreferences d = snapshot.requireData;
          final bool _loggedIn = d.getBool("loggedIn") ?? false;
          // print("PREF STA::: >>> ${d.getBool("loggedIn")}");
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Airtime Slot',
            theme: appTheme,
            home: _controller.hasInternetAccess.value
                ? _loggedIn
                    ? Dashboard(manager: _manager!)
                    : const Welcome()
                : const NoInternet(),
          );
        } ///Users/thankgodokoro/Desktop/code    /Users/thankgodokoro/Desktop/code/Stanley
      },
    );
  }
}

class Splash extends StatefulWidget {
  var controller;
  Splash({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _init() async {
    try {
      // await FirebaseFirestore.instance.collection("stores").snapshots();
    } on SocketException catch (io) {
      widget.controller.setHasInternet(false);
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Container(
      color: lightMode ? Constants.primaryColor : const Color(0xff042a49),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    return await SharedPreferences.getInstance();
  }
}

class Dao {
  String dbValue = "";

  Dao._privateConstructor();

  static Future<Dao> createAsync() async {
    var dao = Dao._privateConstructor();
    // print('Dao.createAsync() called');
    return dao._initAsync();
  }

  /// Simulates a long-loading process such as remote DB connection or device
  /// file storage access.
  Future<Dao> _initAsync() async {
    dbValue =
        await Future.delayed(const Duration(seconds: 5), () => 'Some DB data');
    // print('Dao._initAsync done');
    return this;
  }
}
