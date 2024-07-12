import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/views/auth/login.dart';
import 'package:rolanda/src/views/auth/registration.dart';
import 'package:rolanda/src/views/contact_us.dart';
import 'package:rolanda/src/views/home_view.dart';
import 'package:rolanda/src/views/profile.dart';
import 'package:rolanda/src/views/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(MyMainApp(isFirstLaunch: isFirstLaunch));
}

late TextTheme textTheme;
late Size screenSize;

class MyMainApp extends StatelessWidget {
  const MyMainApp({super.key, required this.isFirstLaunch});
  final bool isFirstLaunch;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    textTheme = Theme.of(context).textTheme;
    const MaterialColor colorPrimarySwatch = MaterialColor(
      0xFF5177FF,
      <int, Color>{
        50: Color(0xFF5177FF),
        100: Color(0xFF5177FF),
        200: Color(0xFF5177FF),
        300: Color(0xFF5177FF),
        400: Color(0xFF5177FF),
        500: Color(0xFF5177FF),
        600: Color(0xFF5177FF),
        700: Color(0xFF5177FF),
        800: Color(0xFF5177FF),
        900: Color(0xFF5177FF),
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        canvasColor: Colors.transparent,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue, foregroundColor: whiteColor)),
        colorScheme: ColorScheme.fromSeed(
          primary: colorPrimarySwatch,
          seedColor: colorPrimarySwatch,
        ),
      ),
      home: isFirstLaunch ? const Welcome() : const Rolanda(),
    );
  }
}

class Rolanda extends StatefulWidget {
  const Rolanda({super.key});

  @override
  State<Rolanda> createState() => _RolandaState();
}

class _RolandaState extends State<Rolanda> {
  final _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    //const Login(),
    const HomeView(),
    Registration(),
    ContactUs(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _pages[_currentPage])),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            //color: redColor,
            boxShadow: [BoxShadow(color: blackColor, blurRadius: 3)],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
              onTap: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.home,
                    color: _currentPage == 0 ? primaryBlue : blackColor,
                  ),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.message,
                    color: _currentPage == 1 ? primaryBlue : blackColor,
                  ),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.call_outlined,
                    color: _currentPage == 2 ? primaryBlue : blackColor,
                  ),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.person_2_outlined,
                    color: _currentPage == 3 ? primaryBlue : blackColor,
                  ),
                )
              ]),
        ),
      ),
      // bottomNavigationBar: DotCurvedBottomNav(
      //     margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      //     backgroundColor: blackColor,
      //     indicatorColor: primaryBlue,
      //     animationDuration: const Duration(milliseconds: 600),
      //     animationCurve: Curves.ease,
      //     selectedIndex: _currentPage,
      // onTap: (index) {
      //   setState(() {
      //     _currentPage = index;
      //   });
      // },
      // items: [
      // Icon(
      //   Icons.home,
      //   color: _currentPage == 0 ? primaryBlue : whiteColor,
      // ),
      // Icon(
      //   Icons.message,
      //   color: _currentPage == 1 ? primaryBlue : whiteColor,
      // ),
      // Icon(
      //   Icons.call_outlined,
      //   color: _currentPage == 2 ? primaryBlue : whiteColor,
      // ),
      // Icon(
      //   Icons.person_2_outlined,
      //   color: _currentPage == 3 ? primaryBlue : whiteColor,
      // ),
      //     ]),
    );
  }
}
