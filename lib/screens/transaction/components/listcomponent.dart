// import 'package:airtimeslot_app/components/text_components.dart';
// import 'package:airtimeslot_app/data/transactions/demo_transactions.dart';
// import 'package:airtimeslot_app/helper/constants/constants.dart';
// import 'package:airtimeslot_app/helper/database/database_handler.dart';
// import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
// import 'package:airtimeslot_app/helper/state/state_controller.dart';
// import 'package:airtimeslot_app/model/transactions/guest_transaction_model.dart';
// import 'package:airtimeslot_app/screens/transaction/transaction_details.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_utils/get_utils.dart';
// import 'package:get/instance_manager.dart';
// import 'package:intl/intl.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import "package:collection/collection.dart";

// import 'autocomplete_tf.dart';
// import 'transaction_row.dart';

// class ListComponent extends StatefulWidget {
//   final PreferenceManager? manager;
//   final List<GuestTransactionModel> guestModel;
//   final List<dynamic> model;
//   const ListComponent({
//     Key? key,
//     this.manager,
//     required this.guestModel,
//     required this.model,
//   }) : super(key: key);

//   @override
//   State<ListComponent> createState() => _ListComponentState();
// }

// class _ListComponentState extends State<ListComponent> {
//   final _searchController = TextEditingController();
//   final _controller = Get.find<StateController>();
//   var _filtered = [];
//   bool _isLoaded = false;
//   var _allMeals;

//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   late List<GuestTransactionModel> _guestList = [];
//   late final List<dynamic> _list = [];

//   List<Widget> _mWidgets = [];

//   _init() async {
//     if (widget.model.isEmpty) {
//       //Revalidate for guest user
//       final resp = await DatabaseHandler().transactions();
//       // for (var v in resp) {
//       //   _guestList.add(v);
//       // }
//       setState(() {
//         _guestList = resp;
//       });
//     } else {
//       //Revalidate for auth user
//       var data = _controller.transactions.value;
//       for (var v in data) {
//         _list.add(v);
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _init();
//     setState(() {
//       _filtered = myTransactions;
//     });
//   }

//   String timeUntil(DateTime date) {
//     return timeago.format(date, locale: "en", allowFromNow: true);
//   }

//   Widget _statusWidget(String status) => Container(
//         padding: const EdgeInsets.all(10.0),
//         color: status.toLowerCase() == "pending" ||
//                 status.toLowerCase() == "initiated"
//             ? Colors.amberAccent
//             : status.toLowerCase() == "success"
//                 ? Colors.green
//                 : Colors.red,
//         child: TextPoppins(
//           text: status,
//           fontSize: 13,
//           color: Colors.white,
//         ),
//       );

//   List<Widget> _buildList() {
//     List<Widget> _widg = [];
//     Map<String?, List<dynamic>> groupByDate = groupBy(
//         _controller.transactions.value,
//         (dynamic obj) => obj['created_at']?.substring(0, 10));

//     groupByDate.forEach((date, list) {
//       // print("$date");

//       // Group
//       var _wid = Column(
//         children: [
//           Container(
//             color: Constants.accentColor,
//             padding: const EdgeInsets.all(10.0),
//             width: double.infinity,
//             child: TextPoppins(
//               text: DateFormat.yMMMEd('en_US').format(DateTime.parse("$date")),
//               fontSize: 17,
//               align: TextAlign.center,
//               fontWeight: FontWeight.w600,
//               color: Constants.primaryColor,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, i) => TextButton(
//               onPressed: () {
//                 showBarModalBottomSheet(
//                   expand: false,
//                   context: context,
//                   topControl: ClipOval(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         width: 32,
//                         height: 32,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(
//                             16,
//                           ),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.close,
//                             size: 24,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   backgroundColor: Colors.white,
//                   builder: (context) => SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.75,
//                     child: 
//                   ),
//                 );
//               },
//               child: TransactionRow(
//                 model: list[i],
//                 guestModel: null,
//               ),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(horizontal: 0.0),
//               ),
//             ),
//             separatorBuilder: (context, i) => const Divider(),
//             itemCount: list.length,
//           ),
//           const SizedBox(height: 16.0),
//         ],
//       );

//       _widg.add(_wid);
//     });

//     return _widg;
//   }

//   List<Widget> _buildGuestList() {
//     List<Widget> _widg = [];

//     var _wid = ListView.separated(
//       shrinkWrap: true,
//       reverse: true,
//       itemBuilder: (context, i) => TextButton(
//         onPressed: () {
//           showBarModalBottomSheet(
//             expand: false,
//             context: context,
//             topControl: ClipOval(
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(
//                       16,
//                     ),
//                   ),
//                   child: const Center(
//                     child: Icon(
//                       Icons.close,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             backgroundColor: Colors.white,
//             builder: (context) => SizedBox(
//               height: MediaQuery.of(context).size.height * 0.75,
//               child: ListView(
//                 padding: const EdgeInsets.all(10.0),
//                 children: [
//                   const SizedBox(
//                     height: 16.0,
//                   ),
//                   TextPoppins(
//                     text: "${recentTransactions.elementAt(i).type} transaction"
//                         .capitalize!,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     align: TextAlign.center,
//                     color: Constants.primaryColor,
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   const SizedBox(height: 16.0),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0,
//                       vertical: 8.0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         TextPoppins(
//                           text: "Email",
//                           fontSize: 14,
//                           color: Constants.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         TextPoppins(
//                           text: recentTransactions.elementAt(i).email,
//                           fontSize: 14,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0,
//                       vertical: 8.0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         TextPoppins(
//                           text: "Amount",
//                           fontSize: 14,
//                           color: Constants.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         Text(
//                           "${Constants.nairaSign(context).currencySymbol}${recentTransactions.elementAt(i).amount}",
//                           style: const TextStyle(fontSize: 14),
//                         )
//                       ],
//                     ),
//                   ),
//                   const Divider(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0,
//                       vertical: 8.0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         TextPoppins(
//                           text: "Payment Method",
//                           fontSize: 14,
//                           color: Constants.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         TextRoboto(
//                           text: recentTransactions.elementAt(i).paymentMethod,
//                           fontSize: 14,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 10.0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         TextPoppins(
//                           text: "Created on",
//                           fontSize: 14,
//                           color: Constants.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         TextRoboto(
//                           text:
//                               "${recentTransactions.elementAt(i).createdAt.substring(0, 10).replaceAll("-", "/")} (${timeUntil(DateTime.parse(recentTransactions.elementAt(i).createdAt))})",
//                           fontSize: 14,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 10.0,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextPoppins(
//                           text: "Description",
//                           fontSize: 14,
//                           color: Constants.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         TextRoboto(
//                           text: recentTransactions.elementAt(i).description,
//                           fontSize: 14,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   (recentTransactions.elementAt(i).status).toLowerCase() ==
//                           "initiated"
//                       ? Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0,
//                             vertical: 10.0,
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             child: TextPoppins(
//                               text: "Complete Transaction",
//                               fontSize: 15,
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                   const SizedBox(height: 36.0),
//                 ],
//               ),
//             ),
//           );
//         },
//         child: TransactionRow(
//           model: null,
//           guestModel: _guestList[i],
//         ),
//         style: TextButton.styleFrom(
//           foregroundColor: Colors.green,
//           padding: const EdgeInsets.symmetric(horizontal: 0.0),
//         ),
//       ),
//       separatorBuilder: (context, i) => const Divider(),
//       itemCount: _guestList.length,
//     );

//     _widg.add(_wid);

//     return _widg;
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     Future.delayed(const Duration(seconds: 1), () {
//       (_list.isEmpty)
//           ? setState(() => _mWidgets = _buildGuestList())
//           : setState(() => _mWidgets = _buildList());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     final double itemHeight = (size.height - kToolbarHeight - 18) / 2.5;
//     final double itemWidth = size.width / 2;

//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const AutoCompleteTextField(),
//           const SizedBox(
//             height: 16.0,
//           ),
//           Expanded(
//             child: ListView.separated(
//               shrinkWrap: true,
//               itemBuilder: (context, i) => GestureDetector(
//                 onTap: () {
//                   showBarModalBottomSheet(
//                     expand: false,
//                     context: context,
//                     topControl: ClipOval(
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Container(
//                           width: 32,
//                           height: 32,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(
//                               16,
//                             ),
//                           ),
//                           child: const Center(
//                             child: Icon(
//                               Icons.close,
//                               size: 24,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     backgroundColor: Colors.white,
//                     builder: (context) => SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.75,
//                       child: TransactionDetails(manager: widget.manager!, guestModel: guestModel, model: model)
//                     ),
//                   );
//                 },
//                 child: TransactionRow()
                
//               ),
//               separatorBuilder: (context, index) => const Divider(),
//               itemCount: _filtered.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
