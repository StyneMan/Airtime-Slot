import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String message;
  final bool goBack;
  InfoDialog({
    required this.message,
    this.goBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: null,
          ),
          child: Wrap(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          Constants.padding,
                        ),
                        topRight: Radius.circular(
                          Constants.padding,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(14.0),
                    child: Stack(
                      children: [
                        Center(
                          child: TextPoppins(
                            text: " Message ",
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          right: 3,
                          top: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 21.0,
                        ),
                        TextPoppins(
                          text: message,
                          align: TextAlign.center,
                          fontSize: 15,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 24.0,
                          ),
                          child: RoundedButton(
                            press: () {
                              Navigator.pop(context);
                              if (goBack) {
                                Navigator.pop(context);
                              }
                            },
                            text: "Done",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
