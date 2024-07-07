import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Reset password",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Password reset link will be sent to your email..",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
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
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    String email = _emailTxtController.text.trim();
                    if (email.isNotEmpty) {
                      if (EmailValidator.validate(email)) {
                        CommonResponses().showLoadingDialog(context);
                        await _auth
                            .sendPasswordResetEmail(email: email)
                            .then((value) {
                          _emailTxtController.clear();
                          CommonResponses()
                              .showToast("Password reset link is sent..");
                          Navigator.pop(context);
                        }).catchError((e) {
                          Navigator.pop(context);
                          CommonResponses().showToast(e.code, isError: true);
                        });
                      } else {
                        CommonResponses().showToast("invalid email format!!");
                      }
                    } else {
                      CommonResponses().showToast("Please fill your email");
                    }
                  },
                  child: AbsorbPointer(
                    child: Container(
                        padding:
                            const EdgeInsets.only(left: 10, top: 4, bottom: 4),
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
            ],
          ),
        ),
      ),
    ));
  }
}
