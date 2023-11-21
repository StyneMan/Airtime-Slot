import 'dart:ui';

import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/preferences/preference_manager.dart';
import 'package:flutter/material.dart';

class GlassCard extends StatefulWidget {
  final PreferenceManager manager;
  var walletBalance;
  final String email;
  GlassCard({
    Key? key,
    required this.email,
    required this.manager,
    required this.walletBalance,
  }) : super(key: key);

  @override
  _GlassCardState createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // image: const DecorationImage(
        //   image: NetworkImage(
        //       'https://static.vecteezy.com/system/resources/thumbnails/001/589/630/small/green-background-with-fading-square-and-dots-free-vector.jpg'),
        //   fit: BoxFit.cover,
        // ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                spreadRadius: 16,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/app_logo.png",
                            width: 64,
                            height: 64,
                          ),
                          Image.asset(
                            "assets/images/card_chip.png",
                            width: 56,
                            height: 56,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Wallet Balance',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Expanded(
                            child: Text(
                              widget.email,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Constants.nairaSign(context).currencySymbol}${widget.walletBalance}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
