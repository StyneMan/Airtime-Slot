import 'dart:typed_data';

import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> makePdf(var data) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/ic_launcher.png'))
          .buffer
          .asUint8List());
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 32,
                    width: 32,
                    child: Image(imageLogo),
                  ),
                  Text(
                    "Data Extra ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: Text(
                "Here are vital information about your transaction",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: PdfColors.black,
                ),
              ),
            ),
            SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Type",
                    style: const TextStyle(
                      fontSize: 14,
                    )),
                Text(
                  "${data['type']}".replaceAll("_", " ").capitalize!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Amount",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                data['status'] != "initiated"
                    ? Text(
                        "${data['entry_type'] == "cr" ? "+" : data['entry_type'] == "dr" ? "-" : ""} NGN${Constants.formatMoneyFloat(double.parse('${data['amount']}'))}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        "NGN${Constants.formatMoneyFloat(double.parse('${data['amount']}'))}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Amount Paid",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "NGN${Constants.formatMoneyFloat(double.parse('${data['amount_paid']}'))}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Reference",
                    style: const TextStyle(
                      fontSize: 14,
                    )),
                Text(
                  "${data['transaction_ref']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Email address",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${data['email']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Payment method",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${data['payment_method']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Description",
                    style: const TextStyle(
                      fontSize: 14,
                    )),
                Text(
                  "${data['description']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Initiated on",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['created_at']))}"
                      .replaceAll("about", "")
                      .replaceAll("minute", "min"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            data['type'] == "electricity" &&
                    data['transaction_meta']['meter_type'] == "prepaid" &&
                    "${data['transaction_meta']['purchased_token']}"
                            .toLowerCase() !=
                        "null"
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Token",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${data['transaction_meta']['purchased_token']}"
                                .capitalize!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Divider(),
                      SizedBox(
                        height: 4.0,
                      ),
                    ],
                  )
                : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Status",
                    style: const TextStyle(
                      fontSize: 14,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: data['status'] == "initiated"
                            ? PdfColors.amber
                            : data['status'] == "success"
                                ? PdfColors.green
                                : PdfColors.red,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "${data['status']}".capitalize!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
