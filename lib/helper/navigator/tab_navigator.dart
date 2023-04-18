import 'package:flutter/material.dart';

import '../../screens/account/account.dart';
import '../../screens/home/home.dart';
import '../../screens/messages/my_messages.dart';
import '../../screens/transaction/transaction.dart';
import '../preference/preference_manager.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatefulWidget {
  TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
    required this.manager,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  final PreferenceManager manager;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    navigatorKey = widget.navigatorKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Home(
      manager: widget.manager,
    );
    if (widget.tabItem == "Home")
      child = Home(
        manager: widget.manager,
      );
    else if (widget.tabItem == "Messages")
      child = MyMessages(
        manager: widget.manager,
      );
    else if (widget.tabItem == "Transaction")
      child = MyTransactions(
        manager: widget.manager,
      );
    else if (widget.tabItem == "Account")
      child = Account(
        manager: widget.manager,
      );

    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
