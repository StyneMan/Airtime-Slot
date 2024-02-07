import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef void InitCallback(String value);

class RoundedDatePicker extends StatelessWidget {
  final String hintText, labelText;
  final InitCallback onSelected;
  final double borderRadius;
  // final ValueChanged<String> onChanged;
  final TextEditingController controller;
  var validator;
  final double height;
  RoundedDatePicker(
      {Key? key,
      required this.hintText,
      required this.labelText,
      required this.controller,
      required this.validator,
      required this.onSelected,
      this.borderRadius = 6.0,
      this.height = 10.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Constants.primaryColor,
      controller: controller,
      validator: validator,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: height,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        hintText: hintText,
        labelText: labelText.isEmpty ? null : labelText,
        focusColor: Constants.accentColor,
        hintStyle: const TextStyle(
          fontFamily: "Poppins",
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        isDense: true,
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2002),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(), //- not to allow to choose after today.
          // lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Constants.primaryColor,
                  onPrimary: Colors.white,
                  onSurface: Constants.primaryColor,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Constants.primaryColor, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          // print(
          //     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          onSelected(
            formattedDate,
          );
        } else {}
      },
      keyboardType: TextInputType.datetime,
    );
  }
}
