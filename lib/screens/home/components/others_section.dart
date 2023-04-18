import 'package:flutter/material.dart';

import '../../../components/text_components.dart';
import '../../../data/services/services_data.dart';
import '../../../helper/preference/preference_manager.dart';

class OthersSection extends StatelessWidget {
  final PreferenceManager manager;
  const OthersSection({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 18) / 2.60;
    final double itemWidth = size.width / 2;

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.shade300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextPoppins(text: "Others", fontSize: 18),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 6.0,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  othersList[index].icon,
                  width: 36,
                  height: 36,
                ),
                Text(
                  othersList[index].title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            itemCount: othersList.length,
          ),
        ],
      ),
    );
  }
}
