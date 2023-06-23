import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class RoundedInputMoney extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool? enabled;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  var validator;
  final Color fillColor;

  final double borderRadius;

  RoundedInputMoney({
    Key? key,
    required this.hintText,
    this.icon = Icons.money,
    this.enabled,
    required this.onChanged,
    required this.controller,
    required this.validator,
    this.borderRadius = 6.0,
    this.fillColor = Constants.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Constants.primaryColor,
      controller: controller,
      validator: validator,
      enabled: enabled,
      inputFormatters: <TextInputFormatter>[
        CurrencyTextInputFormatter(
          locale: 'en',
          decimalDigits: 0,
          symbol: '₦ ',
        ),
      ],
      keyboardType: TextInputType.number,
     decoration: InputDecoration(
       contentPadding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 16.0,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
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
