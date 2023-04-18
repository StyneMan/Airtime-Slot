import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../components/text_components.dart';
import '../../../data/transactions/demo_transactions.dart';
import '../../../helper/constants/constants.dart';
import '../../../helper/preference/preference_manager.dart';
import '../../../helper/state/state_manager.dart';
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
    setState(() {
      _filtered = myTransactions;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoaded = true;
      });
    });
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
          // !_isLoaded
          //     ? Shimmer.fromColors(
          //         child: ListView.separated(
          //           shrinkWrap: true,
          //           itemCount: 4,
          //           physics: const NeverScrollableScrollPhysics(),
          //           separatorBuilder: (context, index) => const Divider(),
          //           itemBuilder: (context, index) => Card(
          //             elevation: 1.0,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             child: SizedBox(
          //               height: 64,
          //               width: MediaQuery.of(context).size.width * 0.90,
          //             ),
          //           ),
          //         ),
          //         baseColor: Colors.grey[300]!,
          //         highlightColor: Colors.grey[100]!,
          //       )
          //     :
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () {
                  showBarModalBottomSheet(
                    expand: false,
                    context: context,
                    topControl: ClipOval(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: ListView(
                        padding: const EdgeInsets.all(10.0),
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          TextPoppins(
                            text:
                                "${myTransactions.elementAt(i).type} transaction"
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
                                  text: myTransactions.elementAt(i).email,
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
                                  "${Constants.nairaSign(context).currencySymbol}${myTransactions.elementAt(i).amount}",
                                  style: const TextStyle(fontSize: 14),
                                )
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
                                      myTransactions.elementAt(i).paymentMethod,
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
                                      "${myTransactions.elementAt(i).createdAt.substring(0, 10).replaceAll("-", "/")} (${timeUntil(DateTime.parse(myTransactions.elementAt(i).createdAt))})",
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
                                  text: myTransactions.elementAt(i).description,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          (myTransactions.elementAt(i).status).toLowerCase() ==
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
                      ),
                    ),
                  );
                },
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
                            "${_filtered.elementAt(i).createdAt.substring(0, 10).replaceAll("-", "/")} (${timeUntil(DateTime.parse(myTransactions.elementAt(i).createdAt))})")
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
          ),
        ],
      ),
    );
  }
}
