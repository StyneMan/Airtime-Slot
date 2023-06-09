import 'package:airtimeslot_app/helper/constants/constants.dart';

import 'text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final Color fillColor;
  var validator;
  final bool? isEnabled;
  final double borderRadius;

  RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    this.capitalization = TextCapitalization.none,
    required this.onChanged,
    required this.controller,
    required this.validator,
    required this.inputType,
    this.borderRadius = 6.0,
    this.isEnabled = true,
    this.fillColor = Constants.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Constants.primaryColor,
      controller: controller,
      validator: validator,
      enabled: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        // labelText: hintText,
        focusColor: fillColor,
        prefixIcon: Icon(icon),
        hintStyle: const TextStyle(
          fontFamily: "Poppins",
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        // labelStyle: const TextStyle(
        //   fontFamily: "Poppins",
        //   fontWeight: FontWeight.w500,
        //   fontSize: 18,
        // ),
      ),
      keyboardType: inputType,
      textCapitalization: capitalization,
    );
  }
}
