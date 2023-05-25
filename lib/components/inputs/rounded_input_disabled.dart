import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class RoundedInputDisabledField extends StatelessWidget {
  final String value;
  final Widget? suffix;
  final String hintText;
  final double borderRadius;

  const RoundedInputDisabledField({
    Key? key,
    required this.value,
    this.suffix,
    required this.hintText,
    this.borderRadius = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      initialValue: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          gapPadding: 4.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          gapPadding: 4.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          gapPadding: 4.0,
        ),
        filled: false,
        hintText: hintText,
        labelText: hintText,
        focusColor: Constants.accentColor,
        hintStyle: const TextStyle(
          fontFamily: "Poppins",
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
