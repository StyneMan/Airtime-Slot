import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';

typedef void InitCallback(String value);

class RoundedDropdownBank extends StatefulWidget {
  final InitCallback onSelected;
  final String placeholder;
  final List<dynamic> items;
  final double borderRadius;
  final Color fillColor;
  var validator;

  RoundedDropdownBank({
    Key? key,
    required this.placeholder,
    required this.onSelected,
    required this.items,
    this.borderRadius = 6.0,
    required this.validator,
    this.fillColor = Constants.accentColor,
  }) : super(key: key);

  @override
  State<RoundedDropdownBank> createState() => _RoundedDropdownState();
}

class _RoundedDropdownState extends State<RoundedDropdownBank> {
  var _modelValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(widget.placeholder),
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17.0,
          vertical: 14.0,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.placeholder,
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
      items: widget.items.map((e) {
        return DropdownMenuItem(
          value: e['name'],
          child: Text(e['name']),
        );
      }).toList(),
      value: _modelValue,
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
