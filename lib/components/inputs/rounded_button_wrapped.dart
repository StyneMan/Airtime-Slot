import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

class RoundedButtonWrapped extends StatelessWidget {
  final String text;
  final Function() press;
  final Color color, textColor;
  final double? height;
  final bool isEnabled;
  const RoundedButtonWrapped({
    Key? key,
    required this.text,
    required this.press,
    this.color = Constants.primaryColor,
    this.isEnabled = true,
    this.textColor = Colors.white,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: height ?? size.height * 0.055,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton() {
    return ElevatedButton(
      onPressed: isEnabled ? press : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          // vertical: 20,
        ),
        textStyle: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(
        text.capitalize!,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
