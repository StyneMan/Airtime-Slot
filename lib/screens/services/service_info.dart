import 'package:airtimeslot_app/components/drawer/custom_drawer.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/forms/service/service_form.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/products/product_model.dart';
import 'package:airtimeslot_app/model/products/product_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceInfo extends StatefulWidget {
  final PreferenceManager manager;
  final String service;
  final bool isAuthenticated;
  final String? mAmount;

  const ServiceInfo({
    Key? key,
    required this.manager,
    this.mAmount,
    required this.service,
    required this.isAuthenticated,
  }) : super(key: key);

  @override
  State<ServiceInfo> createState() => _ServiceInfoState();
}

class _ServiceInfoState extends State<ServiceInfo> {
  final _controller = Get.find<StateController>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductModel? product;
  PreferenceManager? _manager;
  String _token = "";

  _init() async {
    final _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString("accessToken") ?? "";
  }

  // _filterProduct() {
  //   try {
  //     List<ProductModel>? products = [];
  //     if (_controller.products != null) {
  //       ProductResponse body = ProductResponse.fromJson(_controller.products!);
  //       products = body.data;
  //       // var resp = products?.map((e) => e.name == widget.service);
  //       products?.forEach((element) {
  //         if (element.name == widget.service.toLowerCase()) {
  //           setState(() {
  //             product = element;
  //           });
  //         }
  //       });
  //       // resp[0].
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  @override
  void initState() {
    // _filterProduct();
    _init();
    _manager = PreferenceManager(context);
    super.initState();
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: TextPoppins(
          text: widget.service == "Cable_TV"
              ? widget.service.replaceAll("_", " ").toUpperCase()
              : widget.service.toUpperCase(),
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
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
        children: [
          SizedBox(
            height: (widget.service.toLowerCase() == "electricity" ||
                    widget.service.toLowerCase() == "cable_tv")
                ? 8.0
                : 12.0,
          ),
          ServiceForm(
            service: widget.service,
            product: product!,
            isAuthenticated: widget.isAuthenticated,
            token: _token,
            mAmount: widget.mAmount,
          ),
        ],
      ),
      // }),
    );
  }
}
