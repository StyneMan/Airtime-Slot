import 'package:airtimeslot_app/model/networks/mproducts.dart';
import 'package:flutter/material.dart';

typedef void InitCallback(
    int amount, String value, MProduct selectedProduct, String discount);

class RoundedDropdownProduct extends StatefulWidget {
  final InitCallback onSelected;
  final String placeholder;
  final List<MProduct>? products;
  final MProduct? product;
  final double borderRadius;

  final String? value;
  const RoundedDropdownProduct({
    Key? key,
    required this.placeholder,
    required this.products,
    required this.product,
    required this.onSelected,
    this.borderRadius = 6.0,
    this.value = "Select plan",
  }) : super(key: key);

  @override
  State<RoundedDropdownProduct> createState() => _RoundedDropdownState();
}

class _RoundedDropdownState extends State<RoundedDropdownProduct> {
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
          hint: Text(widget.value ?? "Select product"),
          items: widget.products?.map((e) {
            return DropdownMenuItem(
              value: e.name,
              child: Text(e.name),
            );
          }).toList(),

          // value: _modelValue,
          onChanged: (newValue) async {
            MProduct prod = widget.products!
                .firstWhere((element) => element.name == newValue);
            debugPrint("SDS::: ${prod.discountPercent}");
            widget.onSelected(prod.amount!, newValue as String, prod,
                "${prod.discountPercent}");
            setState(
              () {
                _modelValue = prod.name;
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
