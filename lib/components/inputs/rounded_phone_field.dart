import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class RoundedPhoneField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final double borderRadius;
  final Color fillColor;
  var validator;

  RoundedPhoneField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    required this.controller,
    required this.validator,
    required this.inputType,
    this.borderRadius = 6.0,
    this.fillColor = Constants.accentColor,
  }) : super(key: key);

  @override
  State<RoundedPhoneField> createState() => _RoundedPhoneFieldState();
}

class _RoundedPhoneFieldState extends State<RoundedPhoneField> {
  String _countryCode = "+234";
  final String _number = '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      cursorColor: Constants.primaryColor,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17.0,
          vertical: 16.0,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        focusColor: widget.fillColor,
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
        isDense: true,
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
