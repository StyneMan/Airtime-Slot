import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';

typedef void InitCallback(String value);

class RoundedDropdownGender extends StatefulWidget {
  final InitCallback onSelected;
  final String placeholder;
  final List<String> items;
  final double borderRadius;
  var validator;
  final Color fillColor;

  RoundedDropdownGender(
      {Key? key,
      required this.placeholder,
      required this.onSelected,
      required this.items,
      this.validator,
      this.borderRadius = 6.0,
      this.fillColor = Constants.accentColor})
      : super(key: key);

  @override
  State<RoundedDropdownGender> createState() => _RoundedDropdownState();
}

class _RoundedDropdownState extends State<RoundedDropdownGender> {
  var _modelValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(widget.placeholder),
      items: widget.items.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e),
        );
      }).toList(),
      value: _modelValue,
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 12.0,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.placeholder,
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
      onChanged: (newValue) async {
        widget.onSelected(
          newValue as String,
        );
        setState(
          () {
            _modelValue = newValue;
          },
        );
      },
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 30,
      isExpanded: true,
    );
  }
}
