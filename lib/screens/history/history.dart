import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/history/components/item_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _controller = Get.find<StateController>();

  late final List<dynamic> _list = [];
  bool _isHidden = false;

  _init() async {
    var data = _controller.transactions.value;
    debugPrint("TRANSA ${_controller.transactions.value}");
    for (var v in data) {
      _list.add(v);
    }
  }

  List<Widget> _buildList() {
    List<Widget> _widg = [];
    Map<String?, List<dynamic>> groupByDate = groupBy(
        _controller.transactions.value,
        (dynamic obj) => obj['created_at']?.substring(0, 10));

    groupByDate.forEach((date, list) {
      // print("$date");

      // Group
      var _wid = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextPoppins(
            text: DateFormat.yMMMEd('en_US').format(DateTime.parse("$date")),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 6.0),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => TextButton(
              onPressed: () {},
              child: HistoryItemRow(
                data: list[i],
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
              ),
            ),
            separatorBuilder: (context, i) => const Divider(),
            itemCount: list.length,
          ),
          const SizedBox(height: 24.0),
        ],
      );

      _widg.add(_wid);
    });

    return _widg;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.accentColor,
      body: Column(
        children: [
          const SizedBox(height: 48),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: TextPoppins(
                  text: "Transaction History",
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                left: 8.0,
                top: -5,
                bottom: -5,
                child: Center(
                  child: ClipOval(
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36.0),
          Expanded(
            child: Card(
              elevation: 0.0,
              color: Colors.white.withOpacity(.9),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/card_chip.png"),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.98,
                                child: Image.asset(
                                  "assets/images/dash_bg.png",
                                  fit: BoxFit.cover,
                                  height: 144,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 24,
                              left: 16,
                              right: 16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/wallet_icon.svg",
                                                ),
                                                const SizedBox(width: 8.0),
                                                const Text(
                                                  "Wallet Balance",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                              _isHidden
                                                  ? "******"
                                                  : "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(_controller.userData.value['wallet_balance']))}",
                                              style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1.0,
                                            ),
                                            Text(
                                              "${_controller.userData.value['email'] ?? "email@domain.com"}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 21.0),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Swap Balance",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                              _isHidden
                                                  ? "******"
                                                  : "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(_controller.userData.value['withdrawable_balance']))}.00",
                                              style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ClipOval(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        color: Colors.black,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _isHidden =
                                                                  !_isHidden;
                                                            });
                                                          },
                                                          child: Icon(
                                                            _isHidden
                                                                ? CupertinoIcons
                                                                    .eye
                                                                : CupertinoIcons
                                                                    .eye_slash,
                                                            color: Colors.white,
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 21.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    _list.isEmpty
                        ? Center(
                            child: Image.asset(
                              "assets/images/no_record.png",
                              width: 256,
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            children: _buildList(),
                            controller:
                                _controller.transactionsScrollController,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
