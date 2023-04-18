import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../components/drawer/custom_drawer.dart';
import '../../components/text_components.dart';
import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';
import '../../helper/state/state_manager.dart';

class TransactionDetails extends StatefulWidget {
  final String title;
  final PreferenceManager manager;
  const TransactionDetails({
    Key? key,
    required this.title,
    required this.manager,
  }) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();
  var _mStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 18) / 2.60;
    final double itemWidth = size.width / 2;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Constants.primaryColor,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 4.0,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                CupertinoIcons.arrow_left_circle_fill,
                color: Colors.black,
                size: 28,
              ),
            ),
          ],
        ),
        title: TextPoppins(
          text: "${widget.title}".toUpperCase(),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Constants.secondaryColor,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
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
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // pushNewScreen(
                                //   context,
                                //   withNavBar: true,
                                //   screen: Cart(manager: widget.manager),
                                // );
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    CupertinoIcons.shopping_cart,
                                    size: 28,
                                  ),
                                  TextPoppins(
                                    text: "Shopping Cart",
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // pushNewScreen(
                                //   context,
                                //   withNavBar: true,
                                //   screen: PlanCart(manager: widget.manager),
                                // );
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    CupertinoIcons.shopping_cart,
                                    size: 28,
                                  ),
                                  TextPoppins(
                                    text: "Meal Plan Cart",
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: Stack(
              children: [
                const Icon(
                  CupertinoIcons.cart,
                  color: Constants.secondaryColor,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: _controller.cartLength.value < 1
                      ? const SizedBox()
                      : ClipOval(
                          child: Container(
                            width: 14.0,
                            height: 14.0,
                            decoration: BoxDecoration(
                              color: Constants.secondaryColor,
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            child: TextPoppins(
                              text: "${_controller.cartLength.value}",
                              align: TextAlign.center,
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (!_scaffoldKey.currentState!.isEndDrawerOpen) {
                _scaffoldKey.currentState!.openEndDrawer();
              }
            },
            icon: SvgPicture.asset(
              'assets/images/menu_icon.svg',
              color: Constants.secondaryColor,
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
      // body: SafeArea(
      //   child: Container(
      //     padding: const EdgeInsets.all(10.0),
      //     child: StreamBuilder<QuerySnapshot>(
      //       stream: _mStream.snapshots(),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasError) {
      //           return TextPoppins(
      //               text: "Something went wrong. Check your internet",
      //               fontSize: 15);
      //         }
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Shimmer.fromColors(
      //             child: GridView.builder(
      //               shrinkWrap: true,
      //               itemCount: 4,
      //               physics: const NeverScrollableScrollPhysics(),
      //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 2,
      //                 mainAxisSpacing: 10.0,
      //                 crossAxisSpacing: 10.0,
      //                 childAspectRatio: (itemHeight / itemHeight),
      //               ),
      //               itemBuilder: (context, index) => Card(
      //                 elevation: 1.0,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 child: SizedBox(
      //                   height: 210,
      //                   width: MediaQuery.of(context).size.width * 0.42,
      //                 ),
      //               ),
      //             ),
      //             baseColor: Colors.grey[300]!,
      //             highlightColor: Colors.grey[100]!,
      //           );
      //         }
      //         if (snapshot.data!.docs.length < 1) {
      //           return SizedBox(
      //             height: double.infinity,
      //             width: double.infinity,
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 const Icon(
      //                   CupertinoIcons.doc_on_clipboard,
      //                   size: 48,
      //                 ),
      //                 TextPoppins(text: "No record found", fontSize: 14)
      //               ],
      //             ),
      //           );
      //         }

      //         final data = snapshot.requireData;

      //         return GridView.builder(
      //           padding: const EdgeInsets.all(8.0),
      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //             crossAxisCount: 2,
      //             mainAxisSpacing: 4.0,
      //             crossAxisSpacing: 4.0,
      //             childAspectRatio: (itemWidth / itemHeight),
      //           ),
      //           shrinkWrap: true,
      //           itemBuilder: (context, index) => const SizedBox(),
      //           // ProductCard(
      //           //   manager: widget.manager,
      //           //   data: data.docs[index].data(),
      //           // ),
      //           itemCount: data.size,
      //         );
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}
