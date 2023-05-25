import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';


class RoundedPhoneField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final double borderRadius;
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
          horizontal: 24.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          gapPadding: 4.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          gapPadding: 4.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          gapPadding: 4.0,
        ),
        filled: false,
        hintText: widget.hintText,
        labelText: widget.hintText,
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
        isDense: true,
          
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
