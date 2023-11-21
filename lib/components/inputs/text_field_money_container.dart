import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class TextFieldMoneyContainer extends StatelessWidget {
  final Widget child;
  const TextFieldMoneyContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0, top: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Constants.accentColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
