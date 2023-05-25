import 'package:airtimeslot_app/components/text_components.dart';
import 'package:flutter/material.dart';

typedef void InitCallback(String value, selectedNetwork);

class RoundedDropdownAirtimeCash extends StatefulWidget {
  final InitCallback onSelected;
  final String placeholder;
  final List<dynamic> mainList;
  final List<dynamic> subList;
  const RoundedDropdownAirtimeCash({
    Key? key,
    required this.placeholder,
    required this.mainList,
    required this.subList,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<RoundedDropdownAirtimeCash> createState() =>
      _RoundedDropdownAirtimeCashState();
}

class _RoundedDropdownAirtimeCashState
    extends State<RoundedDropdownAirtimeCash> {
  String? _value;

  @override
  void initState() {
    super.initState();
    // setState(() {

    // });
  }

  String _returnIcon(String network) {
    if (network.contains("mtn_num")) {
      return 'https://vattax.deepay.com.ng/image/mtn.png';
    } else if (network.contains("glo_num")) {
      return 'https://vattax.deepay.com.ng/image/glo.png';
    } else if (network.contains("airtel_num")) {
      return 'https://vattax.deepay.com.ng/image/airtel.png';
    } else {
      return 'https://vattax.deepay.com.ng/image/9mobile.png';
    }
  }

  String _returnTitle(String network) {
    if (network.contains("mtn_num")) {
      return 'MTN';
    } else if (network.contains("glo_num")) {
      return 'GLO';
    } else if (network.contains("airtel_num")) {
      return 'Airtel';
    } else {
      return '9Mobile';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton(
        hint: Text(widget.placeholder),
        items: widget.subList.map((e) {
          return DropdownMenuItem(
            value: e['key'],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  _returnIcon(e['key']),
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => Image.asset(
                    "assets/images/placeholder.png",
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(width: 10.0),
                TextRoboto(
                  text: _returnTitle(e['key']),
                  fontSize: 14,
                ),
              ],
            ),
          );
        }).toList(),
        value: _value,
        onChanged: (newValue) {
          setState(
            () {
              _value = newValue as String?;
            },
          );
          widget.onSelected(
            newValue as String,
            widget.mainList.where(
              (element) =>
                  element['key'].toString().toLowerCase().substring(0, 3) ==
                  newValue.toLowerCase().substring(0, 3),
            ),
          );
        },
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        iconSize: 30,
        isExpanded: true,
        underline: const SizedBox(),
      ),
    );
  }
}
