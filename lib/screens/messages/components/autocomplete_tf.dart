import 'package:airtimeslot_app/data/messages/messages.dart';
import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:airtimeslot_app/helper/preferences/preference_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class AutoCompleteTextField extends StatefulWidget {
  const AutoCompleteTextField({Key? key}) : super(key: key);

  @override
  State<AutoCompleteTextField> createState() => _AutoCompleteTextFieldState();
}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField> {
  late List<Messages> autoCompleteData = [];
  PreferenceManager? _manager;

  init() {
    for (var element in messagesList) {
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
    return Autocomplete<Messages>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Messages>.empty();
        } else {
          return autoCompleteData.where(
            (word) => word.title.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
          );
        }
      },
      displayStringForOption: (option) => option.title,
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
            hintText: 'Search message',
          ),
          keyboardType: TextInputType.name,
          focusNode: fieldFocusNode,
          controller: fieldTextEditingController,
        );
      },
      onSelected: (Messages selection) {
        // print('Selected: ${selection.name}');
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<Messages> onSelected,
          Iterable<Messages> options) {
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
                  final Messages option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                      // pushNewScreen(
                      //   context,
                      //   screen:
                      //       MessagesDetail(Messages: option, manager: _manager!),
                      //   withNavBar: true, // OPTIONAL VALUE. True by default.
                      //   pageTransitionAnimation:
                      //       PageTransitionAnimation.cupertino,
                      // );
                    },
                    child: ListTile(
                      title: Text(
                        option.title,
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
