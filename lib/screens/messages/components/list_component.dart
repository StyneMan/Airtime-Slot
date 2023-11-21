import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/data/transactions/demo_transactions.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'autocomplete_tf.dart';

class ListComponent extends StatefulWidget {
  final PreferenceManager manager;
  const ListComponent({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ListComponent> createState() => _ListComponentState();
}

class _ListComponentState extends State<ListComponent> {
  final _searchController = TextEditingController();
  final _controller = Get.find<StateController>();
  var _filtered = [];
  bool _isLoaded = false;
  var _allMeals;

  @override
  void initState() {
    super.initState();
    // if (_controller.menus.value.isNotEmpty) {
    //   setState(() {
    //     _filtered = myTransactions;
    //   });
    // }

    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     _isLoaded = true;
    //   });
    // });
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: "en", allowFromNow: true);
  }

  Widget _statusWidget(String status) => Container(
        padding: const EdgeInsets.all(10.0),
        color: status.toLowerCase() == "pending" ||
                status.toLowerCase() == "initiated"
            ? Colors.amberAccent
            : status.toLowerCase() == "success"
                ? Colors.green
                : Colors.red,
        child: TextPoppins(
          text: status,
          fontSize: 13,
          color: Colors.white,
        ),
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 18) / 2.5;
    final double itemWidth = size.width / 2;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AutoCompleteTextField(),
          const SizedBox(
            height: 16.0,
          ),
          ListView.separated(
            itemBuilder: (context, i) => TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextPoppins(
                        text: "${_filtered.elementAt(i).type} Transaction"
                            .capitalize!,
                        fontSize: 16,
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                          "${_filtered.elementAt(i).createdAt.substring(0, 10).replaceAll("-", "/")} (${timeUntil(DateTime.parse(recentTransactions.elementAt(i).createdAt))})")
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
                        "${Constants.nairaSign(context).currencySymbol}${_filtered.elementAt(i).amount}",
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      _statusWidget(_filtered.elementAt(i).status)
                    ],
                  )
                ],
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: _filtered.length,
          ),
          const SizedBox(
            height: 24.0,
          ),
        ],
      ),
    );
  }
}
