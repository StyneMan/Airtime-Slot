import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
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
                  "assets/images/ic_launcher.png",
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextRoboto(
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
        data['status'] != "initiated" &&
                data['status'] != "cancelled" &&
                data['status'] != "failed"
            ? Text(
                "${data['entry_type'] == "cr" ? "+" : data['entry_type'] == "dr" ? "-" : ""}${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse('${data['amount']}'))}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              )
            : Text(
                "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(data['amount']))}.00",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ],
    );
  }
}
