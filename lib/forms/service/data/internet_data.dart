import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
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

class InternetDataForm extends StatefulWidget {
  InternetDataForm({Key? key}) : super(key: key);

  @override
  State<InternetDataForm> createState() => _InternetDataFormState();
}

class _InternetDataFormState extends State<InternetDataForm> {
  final _amountController = TextEditingController();

  final _phoneController = TextEditingController();

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
                        type: "data",
                        list: _controller.internetData['networks'],
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _controller.selectedDataProvider.value.isEmpty
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
                                  "${Constants.baseURL}${_controller.selectedDataProvider.value['icon']}",
                                  width: 24,
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              TextPoppins(
                                text:
                                    "${_controller.selectedDataProvider.value['name']}",
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
                onPressed: _controller.selectedDataProvider.value.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackageSelector(
                              list: _controller
                                  .selectedDataProvider.value['products'],
                              type: "data",
                              image: _controller
                                  .selectedDataProvider.value['icon'],
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
            child: RoundedPhoneField(
              inputType: TextInputType.number,
              hintText: "Phone number",
              onChanged: (val) {},
              controller: _amountController,
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
