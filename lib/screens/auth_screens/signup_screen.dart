import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iwm/screens/auth_screens/email_verification_screen.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AppDataProvider? _dataProvider;
  final _auth = FirebaseAuth.instance;
  final _usersRef = FirebaseFirestore.instance.collection("USERS");
  String _countryCode = "+255";
  File? _pickedFile;
  final _lNameTxtController = TextEditingController();
  final _fNameTxtController = TextEditingController();
  final _uNameTxtController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailTxtController = TextEditingController();
  final _passwordTxtController = TextEditingController();
  final _cPasswordTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: whiteColor,
        shadowColor: blackColor,
        title: const Text(
          "Sign up",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final res = await ImagePicker.platform.pickImage(
                        source: ImageSource.gallery, imageQuality: 20);
                    if (res != null) {
                      var len = await File(res.path).length();
                      print("before ${len / 1024} KB");
                      CroppedFile? file = await ImageCropper.platform.cropImage(
                          sourcePath: res.path,
                          aspectRatio:
                              const CropAspectRatio(ratioX: 1, ratioY: 1));
                      var len2 = await File(file!.path).length();
                      print(" after ${len2 / 1024} KB");
                      setState(() {
                        _pickedFile = File(file.path);
                      });
                    }
                  },
                  child: _pickedFile == null
                      ? const CircleAvatar(
                          radius: 70,
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ))
                      : Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                              color: redColor,
                              boxShadow: [
                                BoxShadow(color: blackColor, blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.circular(70),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    _pickedFile!,
                                  ))),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 43,
                  child: TextFormField(
                    controller: _fNameTxtController,
                    decoration: const InputDecoration(
                        label: Text("FirstName"),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 43,
                  child: TextFormField(
                    controller: _lNameTxtController,
                    decoration: const InputDecoration(
                        label: Text("Last name"),
                        prefixIcon: Icon(Icons.person_add),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 43,
                  child: TextFormField(
                    controller: _uNameTxtController,
                    decoration: const InputDecoration(
                        label: Text("User name(no space)"),
                        prefixIcon: Icon(Icons.person_pin_sharp),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: FittedBox(
                          fit: BoxFit.contain,
                          child: CountryCodePicker(
                            initialSelection: "tanzania",
                            onChanged: (CountryCode code) {
                              _countryCode = code.toString();
                            },
                          ),
                        ),
                        // contentPadding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        labelText: "Phone number",
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 43,
                  child: TextFormField(
                    controller: _emailTxtController,
                    decoration: const InputDecoration(
                        label: Text("Email address"),
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 43,
                  child: TextFormField(
                    controller: _passwordTxtController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        label: Text("Password"),
                        prefixIcon: Icon(Icons.password_outlined),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 43,
                  child: TextFormField(
                    controller: _cPasswordTxtController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        label: Text("Confirm password"),
                        prefixIcon: Icon(Icons.password_outlined),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      var fName = _fNameTxtController.text;
                      var lName = _lNameTxtController.text;
                      var uName = _uNameTxtController.text;
                      var phone = _phoneController.text;
                      var email = _emailTxtController.text;
                      var pass = _passwordTxtController.text;
                      var cPass = _cPasswordTxtController.text;

                      if (fName.isNotEmpty &&
                          lName.isNotEmpty &&
                          uName.isNotEmpty &&
                          phone.isNotEmpty &&
                          email.isNotEmpty &&
                          pass.isNotEmpty &&
                          cPass.isNotEmpty) {
                        var output = checkPasswordComplexity(pass);
                        if (output == "ok") {
                          if (_pickedFile != null) {
                            if (pass == cPass) {
                              if (EmailValidator.validate(email)) {
                                CommonResponses().showToast("DONE..");
                                CommonResponses().showLoadingDialog(context);
                                var res = await DatabaseServices().signUpUser({
                                  "first_name": fName,
                                  "last_name": lName,
                                  "user_name": uName,
                                  "phone": _countryCode + phone,
                                  "email": email,
                                  "bio": null,
                                  "password": pass,
                                  'followers': [],
                                  'following': [],
                                  "profile_photo": _pickedFile
                                });
                                Navigator.pop(context);
                                if (res['msg'] == "done") {
                                  CommonResponses().showToast(res['data']);
                                  CommonResponses().shiftPage(
                                      context, EmailVerificationScreen(),
                                      kill: true);
                                } else {
                                  CommonResponses()
                                      .showToast(res['msg'], isError: true);
                                }
                              } else {
                                CommonResponses().showToast(
                                    "Invalid email format!!",
                                    isError: true);
                              }
                            } else {
                              CommonResponses().showToast(
                                  "Two passwords must be similar",
                                  isError: true);
                            }
                          } else {
                            CommonResponses().showToast(
                                "Your image is needed!!",
                                isError: true);
                          }
                        } else {
                          CommonResponses().showToast(output!, isError: true);
                        }
                      } else {
                        CommonResponses().showToast(
                            "All details are required!!",
                            isError: true);
                      }
                    },
                    child: AbsorbPointer(
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: blackColor, blurRadius: 4)
                              ]),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Sign up  ",
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Icon(Icons.login))
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  String? checkPasswordComplexity(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }
    return "ok";
  }
}
