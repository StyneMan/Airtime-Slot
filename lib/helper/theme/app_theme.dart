import 'package:airtimeslot_app/helper/constants/constants.dart';
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(elevation: 0.0),
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
        secondary: Constants.accentColor,
        brightness: Brightness.light,
      )
      .copyWith(
        secondary: Constants.accentColor,
      ),
);
