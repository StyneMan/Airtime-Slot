import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../components/text_components.dart';
import '../../../data/services/services_data.dart';
import '../../../helper/preference/preference_manager.dart';
import '../../services/service_info.dart';

class RechargeSection extends StatelessWidget {
  final PreferenceManager manager;
  const RechargeSection({
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
          TextPoppins(text: "Recharge", fontSize: 18),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 6.0,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                pushNewScreen(
                  context,
                  screen: ServiceInfo(
                    manager: manager,
                    serviceName: rechargeList[index].title,
                    data: rechargeList[index],
                  ),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    rechargeList[index].icon,
                    width: 36,
                    height: 36,
                  ),
                  Text(
                    rechargeList[index].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            itemCount: rechargeList.length,
          ),
        ],
      ),
    );
  }
}
