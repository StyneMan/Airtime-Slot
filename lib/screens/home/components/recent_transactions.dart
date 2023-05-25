import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/transaction/components/transaction_row.dart';
import 'package:airtimeslot_app/screens/transaction/transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentTransactions extends StatefulWidget {
  final bool isAuthenticated;
  final PreferenceManager manager;
  const RecentTransactions({
    Key? key,
    required this.isAuthenticated,
    required this.manager,
  }) : super(key: key);

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  bool _loggedIn = true;

  final _controller = Get.find<StateController>();
  List<dynamic> _transactionList = [];

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: "en", allowFromNow: true);
  }

  @override
  Widget build(BuildContext context) {
    return _controller.recentTransactions.value.isEmpty &&
            _transactionList.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextPoppins(text: "Recent Transactions", fontSize: 18),
              const SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Center(
                  child: Image.asset(
                    "assets/images/no_record.png",
                    width: 256,
                  ),
                ),
              ),
            ],
          )
        : Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextPoppins(text: "Recent Transactions", fontSize: 18),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                          child: TransactionDetails(
                            manager: widget.manager,
                            model: _loggedIn
                                ? _controller.recentTransactions.value[i]
                                : null,
                            guestModel: _loggedIn ? null : _transactionList[i],
                          ),
                        ),
                      );
                    },
                    child: TransactionRow(
                      model: _loggedIn
                          ? _controller.recentTransactions.value[i]
                          : null,
                      guestModel: _loggedIn ? null : _transactionList[i],
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _controller.recentTransactions.value.length,
                ),
              ],
            ),
          );
  }
}
