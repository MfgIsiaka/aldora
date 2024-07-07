import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iwm/screens/auth_screens/password_reset_screen.dart';
import 'package:iwm/screens/auth_screens/signup_screen.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _auth = FirebaseAuth.instance;
  final _usersRef = FirebaseFirestore.instance.collection("USERS");
  AppDataProvider? _dataProvider;
  final _emailTxtController = TextEditingController();
  final _passwordTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: whiteColor,
        shadowColor: blackColor,
        title: Text(
          "Sign in",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 43,
                  child: TextFormField(
                    controller: _emailTxtController,
                    decoration: const InputDecoration(
                        label: Text("Email "),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      var email = _emailTxtController.text.trim();
                      var password = _passwordTxtController.text.trim();
                      if (email.isNotEmpty && password.isNotEmpty) {
                        if (EmailValidator.validate(email)) {
                          CommonResponses().showLoadingDialog(context);
                          var res = await DatabaseServices().signInUser(
                              {"email": email, "password": password});
                          Navigator.pop(context);
                          if (res['msg'] == "done") {
                            _dataProvider!.currentUser = res['data'];
                            CommonResponses()
                                .shiftPage(context, HomeScreen(), kill: true);
                          } else {
                            Fluttertoast.showToast(msg: res['msg']);
                          }
                        } else {
                          CommonResponses()
                              .showToast("Invalid email format", isError: true);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "All details are requred!!");
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
                              Text("Sign in  ",
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
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("You forgot password?"),
                    SizedBox(
                        height: 34,
                        child: TextButton(
                            onPressed: () {
                              CommonResponses()
                                  .shiftPage(context, PasswordResetScreen());
                            },
                            child: Text("Reset")))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("You dont have an account?"),
                    SizedBox(
                        height: 34,
                        child: TextButton(
                            onPressed: () {
                              CommonResponses()
                                  .shiftPage(context, SignupScreen());
                            },
                            child: Text("Signup")))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // getLogedInUser() async {
  //   var userId = _auth.currentUser!.uid;
  //   print(userId);
  //   await _usersRef.doc(userId).get().then((value) {
  //     _provider!.currentUser = value.data()!;
  //     CommonResponses().showToast("welcome");
  //     CommonResponses().shiftPage(context, HomeScreen(), kill: true);
  //   }).catchError((e) {
  //     print(e.toString());
  //     //print(e.toString());
  //     //CommonResponses().showToast("Retrying..");
  //     getLogedInUser();
  //   });
  // }
}
