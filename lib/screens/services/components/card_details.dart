import 'package:flutter/material.dart';

import '../../../components/text_components.dart';
import '../../../helper/constants/constants.dart';

class CardDetailTrans extends StatelessWidget {
  var value;
  final String title;
  final IconData icon;
  CardDetailTrans({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                color: Constants.accentColor,
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    icon,
                    color: Constants.primaryColor,
                    size: 32.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextPoppins(
                  text: title,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Constants.primaryColor,
                ),
                Text(
                  "$value",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
