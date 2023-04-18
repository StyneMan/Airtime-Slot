import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';
import '../../helper/state/state_manager.dart';

class ProfileForm extends StatefulWidget {
  final PreferenceManager manager;
  var croppedFile;
  ProfileForm({
    Key? key,
    required this.manager,
    required this.croppedFile,
  }) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _countryCode = "+234";
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  String? _userID;
  String _number = '';
  bool _isEdited = false;
  // var _user;

  Future<void> updateProfile() async {
    _controller.setLoading(true);

    if (_phoneController.text.startsWith('0')) {
      if (mounted) {
        setState(() {
          _number =
              _phoneController.text.substring(1, _phoneController.text.length);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _number = _phoneController.text;
        });
      }
    }

    try {
      // if (_user != null) {
      // await _user?.updateDisplayName(_nameController.text);
      // // user.updatePhoneNumber(phoneCredential)
      // // user.updatePhotoURL(cropp)
      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(_user?.uid)
      //     .set({
      //   "name": _nameController.text,
      //   "phone": "$_countryCode$_number",
      // }, SetOptions(merge: true));

      if (widget.croppedFile != null) {
        // final storageRef = FirebaseStorage.instance.ref();
        // final fileRef = storageRef.child("photos").child("${_user?.uid}");
        // final resp = await fileRef.putFile(File(widget.croppedFile));

        // final url = await resp.ref.getDownloadURL();
        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(_user?.uid)
        //     .set({
        //   "image": url,
        // }, SetOptions(merge: true));
        // await _user?.updatePhotoURL(url);
        // }

        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(_user?.uid)
        //     .get()
        //     .then((value) => _controller.setUserData(value.data()));

        Future.delayed(const Duration(seconds: 3), () {
          _controller.setLoading(false);
          Constants.toast("Profile updated successfully");
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _nameController.text = "John Doe";
        _emailController.text = "example@email.com";
      });
    }
    _phoneController.text =
        _controller.userData.value['phone']?.substring(4) ?? "08093869330";
    // _addressController.text = _controller.userData.value['address'] ?? "";
    // _landmarkController.text = _controller.userData.value['landmark'] ?? "";
    // _ageController.text = _controller.userData.value['age'] ?? "";
    // _heightController.text = _controller.userData.value['height'] ?? "";
    // _startWeightController.text =
    //     _controller.userData.value['startingWeight'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.croppedFile != null) {
      if (mounted) {
        setState(() {
          _isEdited = true;
        });
      }
    }
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Name',
              hintText: 'Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
            onChanged: (val) {
              setState(() {
                _isEdited = true;
              });
            },
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            controller: _nameController,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Email',
              hintText: 'Email',
            ),
            enabled: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Phone Number',
              filled: true,
              prefixIcon: CountryCodePicker(
                alignLeft: false,
                onChanged: (val) {
                  setState(() {
                    _countryCode = val as String;
                  });
                },
                flagWidth: 24,
                initialSelection: 'NG',
                favorite: ['+234', 'NG'],
                showCountryOnly: false,
                showFlag: false,
                showOnlyCountryWhenClosed: false,
              ),
            ),
            maxLength: 11,
            onChanged: (val) {
              setState(() {
                _isEdited = true;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp('^(?:[+0]234)?[0-9]{10}').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              if (value.length < 10) {
                return 'Phone number not valid';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            controller: _phoneController,
          ),
          const SizedBox(height: 8.0),
          const SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isEdited
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          updateProfile();
                        }
                      },
                child: const Text('SAVE CHANGES'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
