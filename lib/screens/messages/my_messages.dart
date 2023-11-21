import 'package:data_extra_app/components/drawer/custom_drawer.dart';
import 'package:data_extra_app/components/text_components.dart';
import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'components/list_component.dart';

class MyMessages extends StatefulWidget {
  final PreferenceManager manager;
  const MyMessages({Key? key, required this.manager}) : super(key: key);

  @override
  State<MyMessages> createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16.0,
            ),
            ClipOval(
              child: Center(
                child: ClipOval(
                  child: Container(
                    color: Colors.white,
                    child: SvgPicture.asset(
                      "assets/images/personal_icon.svg",
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 4.0,
            ),
          ],
        ),
        title: TextPoppins(
          text: "My Messages".toUpperCase(),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        centerTitle: true,
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
          manager: widget.manager,
        ),
      ),
      body: 2 > 1
          ? Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/images/no_record.png",
              ),
            )
          : ListView(
              children: [
                ListComponent(
                  manager: widget.manager,
                ),
              ],
            ),
    );
  }
}
