import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  final BuildContext? context;
  static var prefs;

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  PreferenceManager(this.context) {
    init();
  }

  void saveAccessToken(String token) {
    prefs.setString('accessToken', token);
  }

  void saveEmail(String token) {
    prefs.setString('email', token);
  }

  String getEmail() => prefs != null ? prefs!.getString('email') : '';

  void setIsLoggedIn(bool loggenIn) {
    prefs.setBool('loggedIn', loggenIn);
  }

  bool getIsLoggedIn() => prefs!.getBool('loggedIn') ?? false;

  String getAccessToken() =>
      prefs != null ? prefs!.getString('accessToken') : '';

  void setUserData(String rawJson) {
    prefs!.setString('user', rawJson);
  }

  void updateUserData(String rawJson) {
    prefs!.remove("user");
    Future.delayed(const Duration(seconds: 2), () {
      prefs!.setString('user', rawJson);
    });
  }

  Map getUser() {
    final rawJson = prefs.getString('user') ?? '{}';
    Map<String, dynamic> map = jsonDecode(rawJson);
    return map;
  }

  void clearProfile() {
    prefs!.clear();
  }
}
