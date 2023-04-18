import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/drawer/custom_drawer.dart';
import '../../components/text_components.dart';
import '../../data/services/services_data.dart';
import '../../forms/service/service_form.dart';
import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';

class ServiceInfo extends StatefulWidget {
  final PreferenceManager manager;
  final String serviceName;
  final ServicesData data;
  const ServiceInfo({
    Key? key,
    required this.data,
    required this.manager,
    required this.serviceName,
  }) : super(key: key);

  @override
  State<ServiceInfo> createState() => _ServiceInfoState();
}

class _ServiceInfoState extends State<ServiceInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.white,
        backgroundColor: Constants.primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: TextPoppins(
          text: widget.serviceName,
          fontSize: 18,
          fontWeight: FontWeight.bold,
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ServiceForm(
            token: "",
            service: widget.serviceName,
            product: widget.data.product,
            isAuthenticated: true,
          )
        ],
      ),
    );
  }
}
