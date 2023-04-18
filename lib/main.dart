// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:easyfit_app/components/dashboard/dashboard.dart';
import 'package:easyfit_app/helper/constants/constants.dart';
import 'package:easyfit_app/helper/preference/preference_manager.dart';
import 'package:easyfit_app/helper/state/state_manager.dart';
import 'package:easyfit_app/helper/theme/app_theme.dart';
import 'package:easyfit_app/screens/network/no_internet.dart';
import 'package:easyfit_app/screens/onboarding/walkthrough.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Version { lazy, wait }

// Cmd-line args/Env vars: https://stackoverflow.com/a/64686348/2301224
const String version = String.fromEnvironment('VERSION');
const Version running = version == "lazy" ? Version.lazy : Version.wait;

class GlobalBindings extends Bindings {
  // final LocalDataProvider _localDataProvider = LocalDataProvider();
  @override
  void dependencies() {
    Get.lazyPut<StateController>(() => StateController(), fenix: true);
    // Get.put<StateController>(StateController(), permanent: true);
    // Get.put<LocalDataProvider>(_localDataProvider, permanent: true);
    // Get.put<LocalDataSource>(LocalDataSource(_localDataProvider),
    // permanent: true);
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
  // await Firebase.initializeApp();

  // GlobalBindings().dependencies();
  // Get.put(StateController());

  //WidgetsFlutterBinding.ensureInitialized(); // if needed for resources
  // if (running == Version.lazy) {
  // print('running LAZY version');
  // GlobalBindings().dependencies();
  // }

  // if (running == Version.wait) {
  //   print('running AWAIT version');
  //   await AwaitBindings().dependencies(); // await is key here
  // }

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   systemNavigationBarColor: Constants.accentColor, // navigation bar color
  // ));

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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Payment App',
            theme: appTheme,
            home: _controller.hasInternetAccess.value
                ? 2 == 2
                    ? Walkthrough(manager: _manager!)
                    : Dashboard(manager: _manager!)
                : const NoInternet(),
          );
        }
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
      print("$e");
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
    await Future.delayed(const Duration(seconds: 3));
  }
}

class Dao {
  String dbValue = "";

  Dao._privateConstructor();

  static Future<Dao> createAsync() async {
    var dao = Dao._privateConstructor();
    print('Dao.createAsync() called');
    return dao._initAsync();
  }

  /// Simulates a long-loading process such as remote DB connection or device
  /// file storage access.
  Future<Dao> _initAsync() async {
    dbValue =
        await Future.delayed(const Duration(seconds: 5), () => 'Some DB data');
    print('Dao._initAsync done');
    return this;
  }
}
