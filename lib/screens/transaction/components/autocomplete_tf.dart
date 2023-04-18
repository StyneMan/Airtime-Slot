import 'package:easyfit_app/data/transactions/demo_transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helper/constants/constants.dart';
import '../../../helper/preference/preference_manager.dart';

class AutoCompleteTextField extends StatefulWidget {
  const AutoCompleteTextField({Key? key}) : super(key: key);

  @override
  State<AutoCompleteTextField> createState() => _AutoCompleteTextFieldState();
}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField> {
  // final db = FirebaseFirestore.instance;
  late List<DemoTransactions> autoCompleteData = [];
  PreferenceManager? _manager;

  init() {
    for (var element in myTransactions) {
      autoCompleteData.add(element);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
    _manager = PreferenceManager(context);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<DemoTransactions>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<DemoTransactions>.empty();
        } else {
          return autoCompleteData.where(
            (word) => word.description.contains(
              textEditingValue.text.toLowerCase(),
            ),
          );
        }
      },
      displayStringForOption: (option) => option.description,
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              gapPadding: 2.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              gapPadding: 1.0,
            ),
            prefixIcon: Icon(CupertinoIcons.search),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              gapPadding: 1.0,
            ),
            filled: false,
            hintText: 'Search transaction',
          ),
          keyboardType: TextInputType.name,
          focusNode: fieldFocusNode,
          controller: fieldTextEditingController,
        );
      },
      onSelected: (DemoTransactions selection) {
        debugPrint('Selected: ${selection.description}');
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<DemoTransactions> onSelected,
          Iterable<DemoTransactions> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: Container(
              width: 300,
              height: MediaQuery.of(context).size.height * 0.75,
              color: Constants.accentColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final DemoTransactions option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                      // pushNewScreen(
                      //   context,
                      //   screen:
                      //       ProductDetail(product: option, manager: _manager!),
                      //   withNavBar: true, // OPTIONAL VALUE. True by default.
                      //   pageTransitionAnimation:
                      //       PageTransitionAnimation.cupertino,
                      // );
                    },
                    child: ListTile(
                      title: Text(
                        option.description,
                        style: const TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
