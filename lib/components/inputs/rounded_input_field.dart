import 'package:airtimeslot_app/helper/constants/constants.dart';

import 'text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Widget icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final Color fillColor;
  var validator;
  final bool? isEnabled;
  final bool? isIconed;
  final double borderRadius;
  final double height;

  RoundedInputField({
    Key? key,
    required this.hintText,
    this.labelText = "",
    this.icon = const SizedBox(),
    this.capitalization = TextCapitalization.none,
    required this.onChanged,
    required this.controller,
    required this.validator,
    required this.inputType,
    this.borderRadius = 6.0,
    this.isEnabled = true,
    this.isIconed = false,
    this.height = 18.0,
    this.fillColor = Constants.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Constants.primaryColor,
      controller: controller,
      validator: validator,
      enabled: isEnabled,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: height,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        labelText: labelText.isEmpty ? null : labelText,
        focusColor: fillColor,
        prefixIcon: icon,
        hintStyle: const TextStyle(
          fontFamily: "Poppins",
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        
      ),
      keyboardType: inputType,
      textCapitalization: capitalization,
    );
  }
}
