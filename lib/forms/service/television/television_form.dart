import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_meter_num.dart';
import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/inputs/rounded_phone_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:airtimeslot_app/screens/services/selectors/network_selector.dart';
import 'package:airtimeslot_app/screens/services/selectors/package_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TelevisionForm extends StatefulWidget {
  TelevisionForm({Key? key}) : super(key: key);

  @override
  State<TelevisionForm> createState() => _TelevisionFormState();
}

class _TelevisionFormState extends State<TelevisionForm> {
  final _amountController = TextEditingController();
  final _cardController = TextEditingController();

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Constants.accentColor,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NetworkSelector(
                        type: "cabletv",
                        list: _controller.cableData['networks'],
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _controller.selectedTelevisionProvider.value.isEmpty
                        ? TextPoppins(
                            text: "Service provider",
                            fontSize: 15,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  "${Constants.baseURL}${_controller.selectedTelevisionProvider.value['icon']}",
                                  width: 24,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/logo_big.png',
                                    width: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              TextPoppins(
                                text:
                                    "${_controller.selectedTelevisionProvider.value['name']}",
                                fontSize: 15,
                                color: Colors.black,
                              )
                            ],
                          ),
                    const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      size: 16,
                    )
                  ],
                ),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.all(16.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Constants.accentColor,
              ),
              child: TextButton(
                onPressed: _controller.selectedTelevisionProvider.value.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackageSelector(
                              list: _controller
                                  .selectedTelevisionProvider.value['products'],
                              type: "cabletv",
                              image: _controller
                                  .selectedTelevisionProvider.value['icon'],
                            ),
                          ),
                        );
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _controller.selectedDataPlan.value.isEmpty
                        ? TextPoppins(
                            text: "Data plan",
                            fontSize: 15,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextPoppins(
                                text:
                                    "${_controller.selectedDataPlan.value['name']}",
                                fontSize: 15,
                                color: Colors.black,
                              )
                            ],
                          ),
                    const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      size: 16,
                    )
                  ],
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  padding: const EdgeInsets.all(16.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: RoundedInputMoney(
              hintText: "Amount (NGN)",
              onChanged: (val) {},
              controller: _amountController,
              validator: (val) {},
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: RoundedInputMeterNumber(
              hintText: "Smartcard number",
              onChanged: (val) {},
              controller: _cardController,
              validator: (val) {},
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }
}
