import 'dart:io';

import 'package:data_extra_app/screens/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state/state_controller.dart';

// import '../../util/preference_manager.dart';

class MyApiInterceptor implements InterceptorContract {
  // late PreferenceManager manager;

  final _controller = Get.find<StateController>();

  // MyApiInterceptor(context) {
  //   manager = PreferenceManager(context);
  // }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final cache = await SharedPreferences.getInstance();

      // data.params['appid'] = cache.getString("accessToken");
      // data.params['units'] = 'metric';
      data.headers[HttpHeaders.contentTypeHeader] = "application/json";
      data.headers[HttpHeaders.authorizationHeader] =
          "Bearer " + cache.getString("accessToken")!;
    } on SocketException catch (_) {
      _controller.setLoading(false);
      Fluttertoast.showToast(
        msg: "Check your internet connection!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
    // print("PAYLOADs: => ${data.params}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    try {
      final _prefs = await SharedPreferences.getInstance();

      if (data.statusCode == 401) {
        //Unauthorized. Logout user here...
        debugPrint("LOG THIS USER OUT. SESSION EXPIRED!!!");
        //Clear preference
        _prefs.clear();
        //Go to login screen...
        Get.offAll(Login());
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return data;
  }
}
