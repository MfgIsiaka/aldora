import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _usersRef = FirebaseFirestore.instance.collection("USERS");
  AppDataProvider? _dataProvider;
  final _auth = FirebaseAuth.instance;
  bool _loading = true;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 15), () {
      setState(() {
        _loading = false;
      });
    });
    _checkStatus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify email"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _loading == false
            ? Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await _auth.currentUser!
                          .sendEmailVerification()
                          .then((value) {
                        setState(() {
                          _loading = true;
                        });
                        Future.delayed(Duration(seconds: 50), () {
                          setState(() {
                            _loading = false;
                          });
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appColor, foregroundColor: whiteColor),
                    child: const Text("Resend")),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Open your mail client to verify your email"),
                  CircularProgressIndicator()
                ],
              ),
      ),
    );
  }

  Future<void> _checkStatus() async {
    if (_auth.currentUser!.emailVerified) {
      _timer!.cancel();
      await _usersRef.doc(_auth.currentUser!.uid).get().then((value) {
        if (value.exists) {
          _dataProvider!.currentUser = value.data()!;
          CommonResponses().shiftPage(context, const HomeScreen(), kill: true);
        } else {
          print("Not found!!");
        }
      });
    } else {
      print("Not verified");
    }
    await _auth.currentUser!.reload();
    Future.delayed(Duration(seconds: 5), () async {
      await _checkStatus();
    });
  }
}
