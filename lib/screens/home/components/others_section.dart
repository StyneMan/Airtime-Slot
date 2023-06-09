import 'package:airtimeslot_app/data/services/services_data.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/model/networks/network_product.dart';
import 'package:airtimeslot_app/model/products/product_model.dart';
import 'package:airtimeslot_app/model/products/product_response.dart';
import 'package:airtimeslot_app/screens/services/airtime_swap.dart';
import 'package:airtimeslot_app/screens/wallet/fund_wallet.dart';
import 'package:airtimeslot_app/screens/wallet/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class OthersSection extends StatefulWidget {
  final PreferenceManager manager;
  const OthersSection({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<OthersSection> createState() => _OthersSectionState();
}

class _OthersSectionState extends State<OthersSection> {
  ProductModel? product;
  final _controller = Get.find<StateController>();


  // _filterProduct() {
  //   try {
  //     List<ProductModel>? products = [];
  //     if (_controller.products != null) {
  //       ProductResponse body = ProductResponse.fromJson(_controller.products!);
  //       products = body.data;
  //       // var resp = products?.map((e) => e.name == widget.service);
  //       products?.forEach((element) {
  //         if (element.name == "airtime") {
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
  initState() {
    super.initState();
    // _filterProduct();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 18) / 2.60;
    final double itemWidth = size.width / 2;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextPoppins(text: "Others", fontSize: 18),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 6.0,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                if (othersList.elementAt(index).title == "Fund Wallet") {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.size,
                      alignment: Alignment.bottomCenter,
                      child: FundWallet(
                        manager: widget.manager,
                      ),
                    ),
                  );
                } else if (othersList.elementAt(index).title == "Withdraw") {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.size,
                      alignment: Alignment.bottomCenter,
                      child: Withdraw(
                        manager: widget.manager,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.size,
                      alignment: Alignment.bottomCenter,
                      child: AirtimeSwap(
                        manager: widget.manager,
                        service: "airtime",
                        product: product,
                      ),
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    othersList[index].icon,
                    width: 36,
                    height: 36,
                  ),
                  Text(
                    othersList[index].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            itemCount: othersList.length,
          ),
        ],
      ),
    );
  }
}
