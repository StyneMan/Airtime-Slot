import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../components/drawer/custom_drawer.dart';
import '../../components/glassmorphism/glass_card.dart';
import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';
import '../../helper/state/state_manager.dart';
import 'components/others_section.dart';
import 'components/recent_transactions.dart';
import 'components/recharge_section.dart';

class Home extends StatefulWidget {
  final PreferenceManager? manager;
  const Home({Key? key, this.manager}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
    // _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.white,
        backgroundColor: Constants.primaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                "",
                errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
                  "assets/images/user_icon.svg",
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            RichText(
              text: TextSpan(
                text: "Hi, ",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: ("John Doe").split(' ')[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (!_scaffoldKey.currentState!.isEndDrawerOpen) {
                _scaffoldKey.currentState!.openEndDrawer();
              }
            },
            icon: SvgPicture.asset(
              'assets/images/menu_icon.svg',
              color: Colors.white,
            ),
          ),
        ],
      ),
      endDrawer: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: CustomDrawer(
          manager: widget.manager!,
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Constants.primaryColor,
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/green_pattern.png",
                  fit: BoxFit.cover,
                  height: 200,
                ),
                Positioned(
                  child: GlassCard(
                    manager: widget.manager!,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 21.0,
                ),
                RechargeSection(manager: widget.manager!),
                const SizedBox(
                  height: 8.0,
                ),
                const Divider(
                  thickness: 1.5,
                  color: Constants.accentColor,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                OthersSection(manager: widget.manager!),
                const SizedBox(
                  height: 21,
                ),
                RecentTransactions(),
                const SizedBox(
                  height: 21.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
