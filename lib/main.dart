// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/helper/theme/app_theme.dart';
import 'package:data_extra_app/screens/welcome/splasher.dart';
import 'package:data_extra_app/screens/welcome/welcome.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/dashboard/dashboard.dart';
import 'helper/connectivity/net_conectivity.dart';
import 'helper/constants/constants.dart';
import 'helper/preferences/preference_manager.dart';
import 'helper/state/state_controller.dart';
import 'screens/network/no_internet.dart';

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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _controller = Get.put(StateController());
  Widget? component;
  PreferenceManager? _manager;

  Timer? _timer;
  int _inactiveTimeInSeconds = 300; // 5 minutes in seconds

  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '', _accessToken = "";

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
    _controller.getProducts();

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
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  void _startTimer() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString('accessToken') ?? "";

      setState(() {
        _accessToken = _token;
      });

      if (_token.isNotEmpty) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          // Check if the user has been inactive for more than the specified time
          if (_inactiveTimeInSeconds <= 0) {
            // Log out the user or perform any other actions
            _logoutUser();
            await _prefs.clear();
          } else {
            // Decrease the inactive time counter
            _inactiveTimeInSeconds--;
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _logoutUser() async {
    // Perform logout logic here
    print('User logged out due to inactivity.');
    // You can navigate to the login screen or perform any other actions
    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString('accessToken') ?? "";
      final response = await APIService().logout(_token);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Listen for app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground, reset the timer
      debugPrint("APP IN FOREGROUND");
      if (_inactiveTimeInSeconds > 0) {
        debugPrint("CANCEL TIMER :: ");
        if (_timer != null) {
          // if (_timer!.isActive) {
          _timer?.cancel();
          // }
        }
      }
    } else if (state == AppLifecycleState.paused) {
      // App is in the background, start the timer
      debugPrint("APP IN BACKGROUND");
      if (_accessToken.isNotEmpty) {
        _startTimer();
      }

      //
    }
  }

  @override
  void dispose() {
    // Remove this class as an observer when the widget is disposed
    WidgetsBinding.instance?.removeObserver(this);
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.hasInternetAccess.value == false
          ? const GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: NoInternet(),
            )
          : FutureBuilder(
              future: Init.instance.initialize(),
              builder: (context, AsyncSnapshot snapshot) {
                // Show splash screen while waiting for app resources to load:
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: Splash(
                      controller: _controller,
                    ),
                  );
                } else {
                  // Loading is done, return the app:
                  final SharedPreferences d = snapshot.requireData;
                  final String _token = d.getString("accessToken") ?? "";
                  // print("PREF STA::: >>> ${d.getBool("loggedIn")}");
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Data Extra',
                    theme: appTheme,
                    home: _controller.hasInternetAccess.value
                        ? _token.isNotEmpty
                            ? Dashboard(manager: _manager!)
                            : const Splasher()
                        : const NoInternet(),
                  );
                }
              },
            ),
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
      // widget.controller.setHasInternet(false);
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
