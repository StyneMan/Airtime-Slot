import 'package:flutter/material.dart';

class TextPoppins extends StatelessWidget {
  late final String? text;
  late final double? fontSize;
  late final Color? color;
  late final TextAlign? align;
  late final FontWeight? fontWeight;
  late final bool? softWrap;
  late final TextOverflow? overflow;

  TextPoppins({
    required this.text,
    this.color,
    required this.fontSize,
    this.fontWeight,
    this.align,
    this.softWrap,
    this.overflow,
  });

  final fontFamily = "Poppins";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      softWrap: softWrap,
      textAlign: align,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextRoboto extends StatelessWidget {
  late final String? text;
  late final double? fontSize;
  late final Color? color;
  late final FontWeight? fontWeight;
  late final TextAlign? align;

  TextRoboto(
      {required this.text,
      this.color,
      required this.fontSize,
      this.fontWeight,
      this.align});

  final fontFamily = "Roboto";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextPTSerif extends StatelessWidget {
  late final String? text;
  late final double? fontSize;
  late final Color? color;
  late final FontWeight? fontWeight;
  late final TextAlign? align;

  TextPTSerif(
      {required this.text,
      this.color,
      required this.fontSize,
      this.fontWeight,
      this.align});

  final fontFamily = "PT Serif";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}
