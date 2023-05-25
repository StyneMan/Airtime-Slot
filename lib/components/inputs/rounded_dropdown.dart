import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/model/networks/network_product.dart';
import 'package:flutter/material.dart';

typedef void InitCallback(String value, NetworkProducts selectedNetwork);

class RoundedDropdown extends StatefulWidget {
  final InitCallback onSelected;
  final String placeholder;
  List<NetworkProducts>? networks;
  final String type;
  final double borderRadius;
  RoundedDropdown({
    Key? key,
    required this.placeholder,
    required this.networks,
    required this.onSelected,
    required this.type,
    this.borderRadius = 6.0,
  }) : super(key: key);

  @override
  State<RoundedDropdown> createState() => _RoundedDropdownState();
}

class _RoundedDropdownState extends State<RoundedDropdown> {
  String? _value;

  @override
  void initState() {
    super.initState();
    // setState(() {

    // });
  }

  String _returnIcon(String network, icon) {
    if (network
        .contains("Port Harcourt Electricity Distribution Company (PHEDC)")) {
      return "https://upload.wikimedia.org/wikipedia/en/a/aa/PHED.PNG";
    } else if (network
        .contains("Ikeja Electricity Distribution Company (IKEDC)")) {
      return "https://www.nicepng.com/png/full/29-296765_ikeja-electric-takes-safety-campaign-to-campus-ikeja.png";
    } else if (network
        .contains("Jos Electricity Distribution Company (JEDC)")) {
      return "https://cdn.vanguardngr.com/wp-content/uploads/2020/11/JEDC.png?width=603&auto_optimize=medium";
    } else if (network
        .contains("Kano Electricity Distribution Company (KEDCO)")) {
      return "https://scontent.flos6-1.fna.fbcdn.net/v/t39.30808-6/269671477_5295502113810888_4494654495514221574_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=vCHz6y_p4XgAX_GH_A6&_nc_pt=5&_nc_zt=23&_nc_ht=scontent.flos6-1.fna&oh=00_AT_pb_8NHAJ4VgA-xrGC-hAIEzer_WY3f8hciJhoGVbc9Q&oe=63287493";
    } else if (network
        .contains("Abuja Electricity Distribution Company (AEDC)")) {
      return "https://fmic.gov.ng/wp-content/uploads/2016/12/Leading-reporters-AEDC.jpg";
    } else if (network
        .contains("Eko Electricity Distribution Company (EKEDC)")) {
      return "https://3.bp.blogspot.com/-2xpaZZz22P8/XM0nI1TVr9I/AAAAAAACIsY/tD-8N-aRj_kncJ4C6Gkd3y3DE-09_VJ9QCLcBGAs/s1600/EKEDC-logo.jpg";
    } else if (network.toLowerCase().contains("dstv")) {
      return "https://getlogo.net/wp-content/uploads/2021/05/dstv-logo-vector.png";
    } else if (network.toLowerCase().contains("gotv")) {
      return "https://getlogo.net/wp-content/uploads/2021/05/gotv-nigeria-logo-vector.png";
    } else if (network.toLowerCase().contains("startimes")) {
      return "https://www.digitaltveurope.com/files/2015/03/StarTimes-logoSMALL1.jpg";
    } else {
      return '${"https://vattax.deepay.com.ng/"}$icon';
    }
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
          items: widget.networks?.map((e) {
            return DropdownMenuItem(
              value: e.name,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    _returnIcon(e.name, e.icon),
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
                    text: widget.type.toLowerCase() == "electricity"
                        ? e.name.replaceAll("Electricity Distribution", "-")
                        : e.name,
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
              widget.networks!
                  .firstWhere((element) => element.name == newValue),
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
