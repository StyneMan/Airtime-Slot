import 'package:data_extra_app/components/inputs/rounded_input_field.dart';
import 'package:data_extra_app/components/text_components.dart';

import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageSelector extends StatefulWidget {
  var list;
  final String type, image;
  PackageSelector({
    Key? key,
    required this.list,
    required this.type,
    required this.image,
  }) : super(key: key);

  @override
  State<PackageSelector> createState() => _PackageSelectorState();
}

class _PackageSelectorState extends State<PackageSelector> {
  final _searchController = TextEditingController();
  final _controller = Get.find<StateController>();

  List _filteredList = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    try {
      setState(() {
        _filteredList = widget.list;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _setSelected(int index) {
    setState(() => _selectedIndex = (index + 1));
  }

  _filterList(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty ||
        enteredKeyword == "" ||
        enteredKeyword == " ") {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.list;
      // setState(() {
      //   _filteredList = widget.list;
      // });
    } else {
      results = _filteredList
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _filteredList = results;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      setState(() {
        _filteredList = widget.list;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _selectPackage(var network) {
    switch (widget.type) {
      case "data":
        _controller.selectedDataPlan.value = network;
        break;
      case "cabletv":
        _controller.selectedTelevisionPlan.value = network;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      if (_filteredList.isEmpty) {
        try {
          setState(() {
            _filteredList = widget.list;
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
    return Scaffold(
      backgroundColor: Constants.accentColor,
      body: Column(
        children: [
          const SizedBox(height: 48),
          Stack(
            children: [
              Center(
                child: TextPoppins(
                  text: "Choose an option",
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                left: 16.0,
                top: -5,
                bottom: -5,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Constants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Container(
            width: MediaQuery.of(context).size.width * .86,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: RoundedInputField(
                    hintText: "Search",
                    height: 16.0,
                    onChanged: (val) => _filterList(val),
                    fillColor: Colors.white,
                    icon: const Icon(Icons.search),
                    controller: _searchController,
                    validator: (val) {},
                    inputType: TextInputType.text,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Card(
              color: Colors.white.withOpacity(.9),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                              _selectPackage(_filteredList[index]);
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                Get.back();
                              });
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
                                        "${Constants.baseURL}${widget.image}",
                                        width: 24,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          "assets/images/placeholder.png",
                                          width: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.56,
                                      child: TextPoppins(
                                        text: "${_filteredList[index]['name']}",
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                      itemCount: _filteredList.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
