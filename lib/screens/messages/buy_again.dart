import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../../components/drawer/custom_drawer.dart';
import '../../components/shimmer/banner_shimmer.dart';
import '../../components/text_components.dart';
import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';
import 'components/no_data.dart';

class BuyAgain extends StatefulWidget {
  final String productId;
  final PreferenceManager manager;
  const BuyAgain({Key? key, required this.productId, required this.manager})
      : super(key: key);

  @override
  State<BuyAgain> createState() => _BuyAgainState();
}

class _BuyAgainState extends State<BuyAgain> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLiked = false;
  // int _quantity = 1;
  bool _isLoading = true;
  var productData;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingOverlayPro(
            isLoading: _isLoading,
            progressIndicator: Platform.isAndroid
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const CupertinoActivityIndicator(
                    animating: true,
                  ),
            backgroundColor: Colors.black54,
            child: const SizedBox(
              height: double.infinity,
              width: double.infinity,
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            endDrawer: CustomDrawer(
              manager: widget.manager,
            ),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                _notFound
                    ? const NoDataFound()
                    : Container(
                        color: const Color(0x0FE31414),
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: PinchZoom(
                                child: CachedNetworkImage(
                                  imageUrl: '${productData['image']}',
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          const BannerShimmer(),
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          "assets/images/bottle_placeholder.png"),
                                ),
                                //  Image.network(
                                //   '${productData['image']}',
                                //   fit: BoxFit.contain,
                                //   errorBuilder: (context, error, stackTrace) =>
                                //       Image.asset(
                                //           "assets/images/bottle_placeholder.png"),
                                //   // height: MediaQuery.of(context).size.height * 0.40,
                                // ),
                                resetDuration:
                                    const Duration(milliseconds: 100),
                                maxScale: 2.5,
                                onZoomStart: () {
                                  if (kDebugMode) {
                                    print('Start zooming');
                                  }
                                },
                                onZoomEnd: () {
                                  if (kDebugMode) {
                                    print('Stop zooming');
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                          vertical: 16.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const SizedBox(height: 48),
                                            TextPoppins(
                                                text:
                                                    "${productData['description']}",
                                                fontSize: 13),
                                            // Html(
                                            //   data:
                                            //       "${productData['description']}",
                                            // ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      left: 10,
                                      right: 10,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(36)),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8.0),
                                          height: 66,
                                          color: const Color(0xC5C9C1C1),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${productData['name']}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${Constants.nairaSign(context).currencySymbol}${Constants.formatMoney(productData['price'])}',
                                                        style: const TextStyle(
                                                          color: Constants
                                                              .primaryColor,
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Text(
                                                        "  ${productData['quantity']} in stock"
                                                            .replaceAll(
                                                                ".0", ""),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.end,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.center,
                                              //   children: [
                                              //     Stack(
                                              //       children: [
                                              //         Center(
                                              //           child: Text(
                                              //             "${cart.itemQuantity}",
                                              //             style:
                                              //                 const TextStyle(
                                              //               fontSize: 14,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .w600,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //         Positioned(
                                              //           top: -1,
                                              //           left: 2,
                                              //           right: 2,
                                              //           child: Container(
                                              //             decoration:
                                              //                 const BoxDecoration(
                                              //               color: Constants
                                              //                   .primaryColor,
                                              //               borderRadius:
                                              //                   BorderRadius
                                              //                       .all(
                                              //                 Radius.circular(
                                              //                   4,
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //             child: InkWell(
                                              //               onTap: () {
                                              //                 cart.setItemQuantity(
                                              //                   cart.itemQuantity +
                                              //                       1,
                                              //                 );
                                              //               },
                                              //               child: const Icon(
                                              //                 Icons
                                              //                     .plus_one_rounded,
                                              //                 color: Colors
                                              //                     .white,
                                              //                 size: 16,
                                              //               ),
                                              //             ),
                                              //           ),
                                              //         ),
                                              //         Positioned(
                                              //           bottom: 0,
                                              //           left: 2,
                                              //           right: 2,
                                              //           child: Container(
                                              //             decoration:
                                              //                 const BoxDecoration(
                                              //               color: Constants
                                              //                   .primaryColor,
                                              //               borderRadius:
                                              //                   BorderRadius
                                              //                       .all(
                                              //                 Radius.circular(
                                              //                   4,
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //             child: InkWell(
                                              //               onTap: () {
                                              //                 if (cart.itemQuantity >
                                              //                     1) {
                                              //                   cart.setItemQuantity(
                                              //                     cart.itemQuantity -
                                              //                         1,
                                              //                   );
                                              //                 }
                                              //               },
                                              //               child: const Icon(
                                              //                 Icons
                                              //                     .exposure_minus_1_rounded,
                                              //                 color: Colors
                                              //                     .white,
                                              //                 size: 16,
                                              //               ),
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     const SizedBox(
                                              //       width: 4,
                                              //     ),
                                              //     FloatingActionButton.small(
                                              //       onPressed: (productData[
                                              //                   'quantity']) <
                                              //               1
                                              //           ? () {
                                              //               Constants.toast(
                                              //                   "Product out of stock!");
                                              //             }
                                              //           : () {
                                              //               if (productData ==
                                              //                   null) {
                                              //                 if (productData[
                                              //                         'quantity'] <=
                                              //                     cart.itemQuantity) {
                                              //                   Constants.toast(
                                              //                       "Quantity exceeds available stock!");
                                              //                 } else {
                                              //                   cart
                                              //                       .addProductToCart2(
                                              //                           null,
                                              //                           productData,
                                              //                           cart.itemQuantity)
                                              //                       .then((re) {
                                              //                     // _controller
                                              //                     // .jumpTo(
                                              //                     //     1);
                                              //                     cart.setItemQuantity(
                                              //                         1);
                                              //                   });
                                              //                 }
                                              //               } else {
                                              //                 if (productData[
                                              //                         'quantity'] <=
                                              //                     cart.itemQuantity) {
                                              //                   Constants.toast(
                                              //                       "Quantity exceeds available stock!");
                                              //                 } else {
                                              //                   // cart
                                              //                   //     .addProductToCart(
                                              //                   //         widget
                                              //                   //             .product!,
                                              //                   //         widget
                                              //                   //             .data,
                                              //                   //         cart.itemQuantity)
                                              //                   //     .then((re) {
                                              //                   //   // print("STATUS::: $re");
                                              //                   //   _controller
                                              //                   //       .jumpTo(
                                              //                   //           1);
                                              //                   //   cart.setItemQuantity(
                                              //                   //       1);
                                              //                   // });
                                              //                 }

                                              //                 // _controller.jumpTo(1);

                                              //               }
                                              //             },
                                              //       elevation: 0.0,
                                              //       backgroundColor:
                                              //           Constants.accentColor,
                                              //       child: const Icon(
                                              //         Icons.add_shopping_cart,
                                              //         color: Constants
                                              //             .primaryColor,
                                              //       ),
                                              //     ),
                                              //     FloatingActionButton.small(
                                              //       onPressed: () {
                                              //         // if (!_isLiked) {
                                              //         //   favorites
                                              //         //       .addProductToLikes(
                                              //         //           widget.product,
                                              //         //           widget.data);
                                              //         // } else {
                                              //         //   //remove here...
                                              //         //   if (widget.product !=
                                              //         //       null) {
                                              //         //     favorites.unlikeProduct(
                                              //         //         widget.product);
                                              //         //   } else {
                                              //         //     // print("VALUEE::: ${widget.data()}");
                                              //         //     // print("VALUEE::: ${widget.data()}");
                                              //         //     // print("VALUEE21::: ${widget.data.data()}");
                                              //         //     favorites.unlikeProduct(
                                              //         //       ProductModel.fromJson(
                                              //         //         widget.data.data(),
                                              //         //       ),
                                              //         //     );
                                              //         //   }
                                              //         // }
                                              //         // setState(() =>
                                              //         //     _isLiked = !_isLiked);
                                              //       },
                                              //       elevation: 0.0,
                                              //       backgroundColor:
                                              //           Constants.accentColor,
                                              //       child: !_isLiked
                                              //           ? const Icon(
                                              //               Icons
                                              //                   .favorite_outline,
                                              //               color: Constants
                                              //                   .primaryColor)
                                              //           : const Icon(
                                              //               Icons.favorite,
                                              //               color: Constants
                                              //                   .primaryColor,
                                              //             ),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                Positioned(
                  top: 48,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingActionButton.small(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.white,
                        child: const ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          child: Icon(Icons.arrow_back_ios_new),
                        ),
                        elevation: 4,
                      ),
                      FloatingActionButton.small(
                        onPressed: () {
                          _scaffoldKey.currentState!.openEndDrawer();
                          // if (_scaffoldKey
                          //     .currentState!.isEndDrawerOpen) {
                          //   _scaffoldKey.currentState!.openEndDrawer();
                          // }
                        },
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/menu_icon.svg',
                            color: Constants.primaryColor,
                          ),
                        ),
                        elevation: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
