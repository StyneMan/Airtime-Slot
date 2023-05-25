import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/model/transactions/guest_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransactionRow extends StatelessWidget {
  final GuestTransactionModel? guestModel;
  var model;
  TransactionRow({
    Key? key,
    this.guestModel,
    this.model,
  }) : super(key: key);

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: "en", allowFromNow: true);
  }

  Widget _statusWidget(String status) => ClipOval(
        child: Container(
          padding: const EdgeInsets.all(2.0),
          color: status.toLowerCase() == "pending" ||
                  status.toLowerCase() == "initiated"
              ? Colors.amberAccent
              : status.toLowerCase() == "success"
                  ? Colors.green
                  : Colors.red,
          child: Icon(
            status.toLowerCase() == "pending" ||
                    status.toLowerCase() == "initiated"
                ? Icons.more_horiz_rounded
                : status.toLowerCase() == "success"
                    ? Icons.done_all_rounded
                    : Icons.close,
            color: Colors.white,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextRoboto(
              text:
                  "${"${model['type'] ?? guestModel?.type}".toLowerCase() == "fund_wallet" ? "Fund Wallet" : "${model['type'] ?? guestModel?.type}".toLowerCase() == "airtime_swap" ? "Airtime Swap" : "${model['type'] ?? guestModel?.type}"} Transaction"
                      .capitalize!,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              "${"${model['created_at'] ?? guestModel?.createdAt}".substring(0, 10).replaceAll("-", "/")} (${timeUntil(DateTime.parse("${model['created_at'] ?? guestModel?.createdAt}"))})",
              style: const TextStyle(color: Constants.accentColor),
            )
          ],
        ),
        const SizedBox(
          width: 8.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${Constants.nairaSign(context).currencySymbol}${model['amount'] ?? guestModel?.amount}",
            ),
            const SizedBox(
              height: 4.0,
            ),
            _statusWidget("${model['status'] ?? guestModel?.status}")
          ],
        )
      ],
    );
  }
}
