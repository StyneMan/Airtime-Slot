import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'text_field_money_container.dart';

class RoundedInputMeterNumber extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  var validator;
  final bool? enabled;
  final double borderRadius;
  final Color fillColor;

  RoundedInputMeterNumber(
      {Key? key,
      required this.hintText,
      this.icon = Icons.money,
      this.enabled = true,
      required this.onChanged,
      required this.controller,
      required this.validator,
      this.borderRadius = 6.0,
      this.fillColor = Constants.accentColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Constants.primaryColor,
      controller: controller,
      validator: validator,
      enabled: enabled,
      inputFormatters: <TextInputFormatter>[
        MaskTextInputFormatter(
          mask: '#### #### #### #### #### ####',
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy,
        )
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22.0,
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
