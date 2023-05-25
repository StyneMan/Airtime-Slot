import 'package:flutter/material.dart';

typedef void InitCallback(String value);

class RoundedDropdownGender extends StatefulWidget {
  final InitCallback onSelected;
  final String placeholder;
  final List<String> items;
  final double borderRadius;

  RoundedDropdownGender({
    Key? key,
    required this.placeholder,
    required this.onSelected,
    required this.items,
    this.borderRadius = 6.0,
  }) : super(key: key);

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: DropdownButton(
          hint: Text(widget.placeholder),
          items: widget.items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
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
          underline: const SizedBox(),
        ),
      ),
    );
  }
}
