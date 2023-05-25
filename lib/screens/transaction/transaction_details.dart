import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/transactions/guest_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get/instance_manager.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransactionDetails extends StatefulWidget {
  final PreferenceManager manager;
  final GuestTransactionModel? guestModel;
  var model;
  TransactionDetails({
    Key? key,
    required this.manager,
    required this.guestModel,
    required this.model,
  }) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();
  var _mStream;

  @override
  void initState() {
    super.initState();
  }

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
                ? Icons.pending_sharp
                : status.toLowerCase() == "success"
                    ? Icons.done_all_rounded
                    : Icons.close,
            color: Colors.white,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 18) / 2.60;
    // final double itemWidth = size.width / 2;

    return ListView(
      padding: const EdgeInsets.all(10.0),
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _statusWidget(
                "${widget.model['status'] ?? widget.guestModel?.status}"),
            TextPoppins(
              text: "${widget.model['status'] ?? widget.guestModel?.status}".capitalize,
              fontSize: 16,
              align: TextAlign.center,
              color: "${widget.model['status'] ?? widget.guestModel?.status}"
                              .toLowerCase() ==
                          "pending" ||
                      "${widget.model['status'] ?? widget.guestModel?.status}"
                              .toLowerCase() ==
                          "initiated"
                  ? Colors.amberAccent
                  : "${widget.model['status'] ?? widget.guestModel?.status}"
                              .toLowerCase() ==
                          "success"
                      ? Colors.green
                      : Colors.red,
            ),
          ],
        ),
        const SizedBox(
          height: 24.0,
        ),
        TextPoppins(
          text: "${widget.model['type'] ?? widget.guestModel?.type} transaction"
              .capitalize!,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          align: TextAlign.center,
          color: Constants.primaryColor,
        ),
        const SizedBox(
          height: 16,
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextPoppins(
                text: "Email",
                fontSize: 14,
                color: Constants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              TextPoppins(
                text: "${widget.model['email'] ?? widget.guestModel?.email}",
                fontSize: 14,
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextPoppins(
                text: "Amount",
                fontSize: 14,
                color: Constants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              Text(
                "${Constants.nairaSign(context).currencySymbol}${widget.model['amount'] ?? widget.guestModel?.amount}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextPoppins(
                text: "Payment Method",
                fontSize: 14,
                color: Constants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              TextRoboto(
                text:
                    "${widget.model['payment_method'] ?? widget.guestModel?.paymentMethod}",
                fontSize: 14,
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextPoppins(
                text: "Created on",
                fontSize: 14,
                color: Constants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              TextRoboto(
                text:
                    "${"${widget.model['created_at'] ?? widget.guestModel?.createdAt}".substring(0, 10).replaceAll("-", "/")} (${timeUntil(DateTime.parse("${widget.model['created_at'] ?? widget.guestModel?.createdAt}"))})",
                fontSize: 14,
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextPoppins(
                text: "Description",
                fontSize: 14,
                color: Constants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              TextRoboto(
                text:
                    "${widget.model['description'] ?? widget.guestModel?.description}",
                fontSize: 14,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        (widget.model['status'] ?? widget.guestModel?.status).toLowerCase() ==
                "initiated"
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  child: TextPoppins(
                    text: "Complete Transaction",
                    fontSize: 15,
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 36.0),
      ],
    );
  }
}
