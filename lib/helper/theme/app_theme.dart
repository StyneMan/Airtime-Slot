import 'package:easyfit_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appTheme = ThemeData(
  primaryColor: Constants.primaryColor,
  primaryColorBrightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle:
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
  ),
  textTheme: const TextTheme(
    bodyText2: TextStyle(),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  inputDecorationTheme: const InputDecorationTheme(
    focusColor: Constants.primaryColor,
    filled: true,
    // fillColor: Color(0xFFEDF8F9),
    // labelStyle: TextStyle(
    //   color: Constants.primaryColor,
    // ),
    hintStyle: TextStyle(
      color: Colors.black38,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Constants.primaryColor,
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Constants.primaryColor,
    foregroundColor: Constants.primaryColor,
  ),
  colorScheme: ThemeData()
      .colorScheme
      .copyWith(
        primary: Constants.primaryColor,
        secondary: const Color(0xFF64EE85),
        brightness: Brightness.light,
      )
      .copyWith(
        secondary: const Color(0xFF64EE85),
      ),
);
