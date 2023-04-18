import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/text_components.dart';
import '../../helper/constants/constants.dart';
import '../../helper/state/state_manager.dart';
import '../../screens/auth/account_created/successscreen.dart';

typedef InitCallback(bool params);

class SignupForm extends StatefulWidget {
  // final InitCallback onLoading;
  SignupForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _countryCode = "+234";
  bool _obscureText = true, _loading = false;

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  String _number = '';
  String _code = "";

  _setCode(val) {
    setState(() {
      _code = val;
    });
  }

  _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _register() async {
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

    Future.delayed(const Duration(seconds: 3), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextPoppins(
                  text: "Set Wallet PIN",
                  fontSize: 24,
                  align: TextAlign.center,
                  color: Constants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Enter PIN")),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _controller.setLoading(true);
                      Future.delayed(const Duration(seconds: 3), () {
                        _controller.setLoading(false);

                        Navigator.of(context).pushReplacement(
                          PageTransition(
                            type: PageTransitionType.size,
                            alignment: Alignment.bottomCenter,
                            child: const AccountSuccess(),
                          ),
                        );
                      });
                    },
                    child: Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    // final _auth = FirebaseAuth.instance;

    // try {
    //   final resp = await _auth.createUserWithEmailAndPassword(
    //     email: _emailController.text,
    //     password: _passwordController.text,
    //   );

    //   if (resp.user != null) {
    //     resp.user!.updateDisplayName(_nameController.text);
    //   }

    //   await _auth.verifyPhoneNumber(
    //     phoneNumber: "$_countryCode$_number",
    //     verificationCompleted: (PhoneAuthCredential credential) {
    //       _controller.setLoading(false);
    //       // resp.user!.updatePhoneNumber(credential);
    //     },
    //     verificationFailed: (FirebaseAuthException e) {
    //       _controller.setLoading(false);
    //       if (e.code == 'invalid-phone-number') {
    //         print('The provided phone number is not valid.');
    //         Constants.toast('The provided phone number is not valid.');
    //       } else {
    //         print("${e.code} - ${e.message}");
    //         Constants.toast('${e.message}');
    //       }
    //       _auth.currentUser?.delete();
    //     },
    //     codeSent: (String verificationId, int? resendToken) {
    //       _controller.setLoading(false);
    //       //show dialog to take input from the user
    //       showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) => VerifyOTP(
    //           caller: "Register",
    //           email: _emailController.text,
    //           pass: _passwordController.text,
    //           name: _nameController.text,
    //           phone: "$_countryCode$_number",
    //           credential: resp,
    //           verificationId: verificationId,
    //           onEntered: _setCode,
    //         ),
    //       );
    //     },
    //     codeAutoRetrievalTimeout: (String verificationId) {
    //       _controller.setLoading(false);
    //     },
    //   );
    //   // _auth.verifyPhoneNumber(phoneNumber: _phoneController.text, verificationCompleted: null, verificationFailed: verificationFailed, codeSent: codeSent, codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
    // } on FirebaseAuthException catch (e) {
    //   switch (e.code) {
    //     case "email-already-in-use":
    //       Constants.toast('Email address already in use');
    //       break;
    //     case "invalid-email":
    //       Constants.toast('Email is not valid. Try again');
    //       break;
    //     case "weak-password":
    //       Constants.toast('Password too weak. Use a stronger password');
    //       break;
    //     case "expired-action-code":
    //       Constants.toast('The OTP code has expired.');
    //       break;
    //     case "invalid-action-code":
    //       Constants.toast('Incorrect code entered.');
    //       break;
    //     default:
    //       Constants.toast('${e.message}');
    //   }
    //   _controller.setLoading(false);
    //   _auth.currentUser?.delete();
    //   // Constants.toast('${e.message}');
    //   // print("ERR:: ${e.code} - ${e.message}");

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              filled: false,
              labelText: 'Full Name',
              hintText: 'Full Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your fullname';
              }
              return null;
            },
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            controller: _nameController,
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              filled: false,
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
              labelText: 'Phone Number',
              hintText: 'Phone Number',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your number';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            controller: _phoneController,
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              filled: false,
              labelText: 'Email',
              hintText: 'Email',
            ),
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
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 2.0,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                gapPadding: 1.0,
              ),
              filled: false,
              labelText: 'Password',
              hintText: 'Password',
              suffixIcon: IconButton(
                onPressed: () => _togglePass(),
                icon: Icon(
                  _obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please type password';
              }
              return null;
            },
            obscureText: _obscureText,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 13.0,
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // widget.onLoading(_loading);
                  //Now go to otp page
                  _register();
                }
              },
              child: TextPoppins(
                text: "Create account",
                fontSize: 14,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                primary: Constants.primaryColor,
                onPrimary: Colors.white,
                elevation: 0.2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
