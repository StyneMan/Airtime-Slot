// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:airtimeslot_app/data/messages/messages.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/model/transactions/guest_transaction_model.dart';
import 'package:airtimeslot_app/model/transactions/user/user_transaction.dart';
import 'package:airtimeslot_app/screens/account/account.dart';
import 'package:airtimeslot_app/screens/home/home.dart';
import 'package:airtimeslot_app/screens/messages/my_messages.dart';
import 'package:airtimeslot_app/screens/transaction/pay.dart';
import 'package:flutter/material.dart';

import 'auth_controller.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatefulWidget {
  final PreferenceManager manager;
  final List<GuestTransactionModel> guestModel;
  final List<UserTransaction> model;

  const TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
    required this.manager,
    required this.guestModel,
    required this.model,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  Widget build(BuildContext context) {
    Widget child = const Home();
    if (widget.tabItem == "Home")
      child = Home(
        manager: widget.manager,
      );
    else if (widget.tabItem == "Pay")
      child = Pay(
        manager: widget.manager,
      );
    else if (widget.tabItem == "Messages")
      child = AuthController(
        manager: widget.manager,
        child: MyMessages(
          manager: widget.manager,
        ),
      );
    else if (widget.tabItem == "Account")
      child = AuthController(
        manager: widget.manager,
        child: Account(
          manager: widget.manager,
        ),
      );

    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
