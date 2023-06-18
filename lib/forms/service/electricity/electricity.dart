import 'package:airtimeslot_app/components/inputs/rounded_button.dart';
import 'package:airtimeslot_app/components/inputs/rounded_dropdown.dart';
import 'package:airtimeslot_app/components/inputs/rounded_dropdown_gender.dart';
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

class ElectricityForm extends StatefulWidget {
  ElectricityForm({Key? key}) : super(key: key);

  @override
  State<ElectricityForm> createState() => _ElectricityFormState();
}

class _ElectricityFormState extends State<ElectricityForm> {
  final _amountController = TextEditingController();

  final _meterNumController = TextEditingController();

  final _controller = Get.find<StateController>();

  void _onSelected(val) {

  }

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
                        type: "electricity",
                        list: _controller.electricityData['networks'],
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _controller.selectedElectricityProvider.value.isEmpty
                        ? TextPoppins(
                            text: "Electricity company",
                            fontSize: 15,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  "${Constants.baseURL}${_controller.selectedElectricityProvider.value['icon']}",
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.64,
                                child: Wrap(
                                  children: [
                                    TextPoppins(
                                      text:
                                          "${_controller.selectedElectricityProvider.value['name']}",
                                      fontSize: 15,
                                      color: Colors.black,
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),
                              ),
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
              hintText: "Meter number",
              onChanged: (val) {},
              controller: _meterNumController,
              validator: (val) {},
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: RoundedDropdownGender(
              placeholder: "Meter type",
              validator: (val) {},
              onSelected: _onSelected,
              items: const ["Postpaid", "Prepaid"],
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
