import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:airtimeslot_app/model/onboarding/onboarding_model.dart';
import 'package:airtimeslot_app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class Walkthrough extends StatefulWidget {
  final PreferenceManager manager;
  const Walkthrough({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<Walkthrough> createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Image.asset(
                "assets/images/logo.png",
               
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Center(
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                      _pageController.animateToPage(
                        currentIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: onboardingList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            onboardingList[index].image,
                            width: MediaQuery.of(context).size.width * 0.86,
                            height: MediaQuery.of(context).size.height * 0.34,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextPoppins(
                            text: onboardingList[index].title,
                            fontSize: 34,
                            align: TextAlign.left,
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextPoppins(
                            text: onboardingList[index].description,
                            fontSize: 15,
                            align: TextAlign.justify,
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: currentIndex == 2
                        ? null
                        : () {
                            pushNewScreen(
                              context,
                              screen: const Welcome(),
                              withNavBar:
                                  true, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                    child: TextPoppins(
                      text: "skip",
                      fontSize: 24,
                      color: currentIndex == 2
                          ? Colors.grey
                          : Constants.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: onboardingList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _pageController.animateToPage(
                            entry.key,
                            duration: const Duration(),
                            curve: Curves.easeIn,
                          ),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Constants.primaryColor
                                      : Constants.accentColor)
                                  .withOpacity(
                                currentIndex == entry.key ? 0.9 : 0.4,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (currentIndex == 2) {
                        pushNewScreen(
                          context,
                          screen: const Welcome(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      } else {
                        _pageController.animateToPage(
                          currentIndex + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: TextPoppins(
                      text: "next",
                      fontSize: 24,
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
