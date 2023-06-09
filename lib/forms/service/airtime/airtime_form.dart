import 'package:airtimeslot_app/components/inputs/rounded_input_money.dart';
import 'package:airtimeslot_app/components/inputs/rounded_phone_field.dart';
import 'package:airtimeslot_app/components/text_components.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/state/state_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirtimeForm extends StatefulWidget {
  final String type;
  const AirtimeForm({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<AirtimeForm> createState() => _AirtimeFormFormState();
}

class _AirtimeFormFormState extends State<AirtimeForm> {
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _controller = Get.find<StateController>();
  int _selectedIndex = 0;

  _setSelected(int index) {
    setState(() => _selectedIndex = (index + 1));
  }

  _selectNetwork(var network) {
    switch (widget.type) {
      case "data":
        _controller.selectedDataProvider.value = network;
        _controller.selectedDataPlan.value = {};
        break;
      case "airtime":
        _controller.selectedAirtimeProvider.value = network;
        break;
      case "electricity":
        _controller.selectedElectricityProvider.value = network;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
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
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Constants.accentColor,
                ),
                child: TextButton(
                  onPressed: () {
                    _setSelected(index);
                    _selectNetwork(
                        _controller.airtimeData.value['networks'][index]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              "${Constants.baseURL}${_controller.airtimeData.value['networks'][index]['icon']}",
                              width: 24,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          TextPoppins(
                            text:
                                "${_controller.airtimeData.value['networks'][index]['name']}",
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.check_circle,
                        size: 18,
                      )
                    ],
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: index == (_selectedIndex - 1)
                        ? Colors.green
                        : Constants.checkBg,
                    padding: const EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(
              height: 10.0,
            ),
            itemCount: _controller.airtimeData.value['networks']?.length,
          ),
        ],
      ),
    );
  }
}
