import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iwm/screens/auth_screens/signin_screen.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  AppDataProvider? _dataProvider;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _dataProvider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () async {
                await _auth.signOut().then((value) {
                  _dataProvider!.currentUser = {};
                  CommonResponses()
                      .shiftPage(context, SigninScreen(), kill: true);
                }).catchError((e) {});
              },
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
