import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';

typedef Presser();

class ActionDialog extends StatelessWidget {
  final String message;
  final Presser action;
  // final String title;
  ActionDialog({required this.message, required this.action});

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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: TextPoppins(
                                    text: "Cancel",
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(6.0)),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: action,
                                  child: TextPoppins(
                                    text: "Proceed",
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(6.0)),
                                ),
                              ),
                            ],
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
