import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryItemRow extends StatelessWidget {
  var data;
  HistoryItemRow({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(
                  "assets/images/logo_big.png",
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextPoppins(
                    text: "${data['description']}",
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextPoppins(
                  text:
                      " ${DateFormat.jm().format(DateTime.parse(data['created_at']))}",
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          width: 6.0,
        ),
        TextRoboto(
          text:
              "-${Constants.formatMoneyFloat(double.parse(data['amount']))}.00",
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
