import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iwm/screens/auth_screens/signin_screen.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:provider/provider.dart';
import 'package:typewritertext/typewritertext.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuth.instance;
  AppDataProvider? _dataProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 10), () async {
      if (_auth.currentUser != null) {
        var user =
            await DatabaseServices().getSingleUser(_auth.currentUser!.uid);
        if (user['msg'] == "done") {
          _dataProvider!.currentUser = user['data'];
          CommonResponses().shiftPage(context, const HomeScreen(), kill: true);
        } else {
          CommonResponses().showToast(user['msg'], isError: true);
        }
      } else {
        CommonResponses().shiftPage(context, const SigninScreen(), kill: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _dataProvider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: whiteColor,
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(50),
                      image: const DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          'assets/images/logo.png',
                        ),
                      )),
                ),
              ),
              Text(
                "Aldora",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Container(
                width: screenSize.width,
                child: TypeWriterText(
                  alignment: Alignment.center,
                  text: Text(
                    "Where everything happens",
                    style: TextStyle(
                        fontSize: 22, fontFamily: 'app-font', color: appColor),
                  ),
                  duration: const Duration(milliseconds: 100),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
