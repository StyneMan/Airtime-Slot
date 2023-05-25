import 'package:flutter/material.dart';

typedef void InitCallback(String value);

class RoundedDropdownBank extends StatefulWidget {
  final InitCallback onSelected;
  final String placeholder;
  final List<dynamic> items;
  final double borderRadius;

  RoundedDropdownBank({
    Key? key,
    required this.placeholder,
    required this.onSelected,
    required this.items,
    this.borderRadius = 6.0,
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
          underline: const SizedBox(),
        ),
      ),
    );
  }
}
