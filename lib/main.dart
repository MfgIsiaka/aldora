import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/views/auth/login.dart';
import 'package:rolanda/src/views/auth/registration.dart';
import 'package:rolanda/src/views/contact.dart';
import 'package:rolanda/src/views/profile.dart';
import 'package:rolanda/src/views/welcome_page.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Rolanda()));
}

class Rolanda extends StatefulWidget {
  const Rolanda({super.key});

  @override
  State<Rolanda> createState() => _RolandaState();
}

class _RolandaState extends State<Rolanda> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    const Login(),
    Registration(),
    ContactUs(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_currentPage],
        bottomNavigationBar: DotCurvedBottomNav(
            backgroundColor: blackColor,
            indicatorColor: primaryBlue,
            animationDuration: const Duration(milliseconds: 600),
            animationCurve: Curves.ease,
            selectedIndex: _currentPage,
            onTap: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            items: [
              Icon(
                Icons.home,
                color: _currentPage == 0 ? primaryBlue : whiteColor,
              ),
              Icon(
                Icons.message,
                color: _currentPage == 1 ? primaryBlue : whiteColor,
              ),
              Icon(
                Icons.call_outlined,
                color: _currentPage == 2 ? primaryBlue : whiteColor,
              ),
              Icon(
                Icons.person_2_outlined,
                color: _currentPage == 3 ? primaryBlue : whiteColor,
              ),
            ]),
      ),
    );
  }
}
