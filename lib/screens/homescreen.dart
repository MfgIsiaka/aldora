import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:iwm/screens/auth_screens/profile_screen.dart';
import 'package:iwm/screens/auth_screens/signin_screen.dart';
import 'package:iwm/screens/create_post_screen.dart';
import 'package:iwm/screens/home_screen_tabs/home_tab.dart';
import 'package:iwm/screens/home_screen_tabs/search_tab.dart';
import 'package:iwm/screens/notification_screen.dart';
import 'package:iwm/screens/post_details_screen.dart';
import 'package:iwm/screens/user_screen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final ValueNotifier<List> filteredUsers = ValueNotifier<List>([]);
final ValueNotifier<bool> something = ValueNotifier<bool>(false);

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  Function(void Function())? _stateSetter;
  int _currentPageIndex = 0;
  double searchWidth = 40;
  final _usersRef = FirebaseFirestore.instance.collection("USERS");
  final _postsRef = FirebaseFirestore.instance.collection("POSTS");
  final _notificationsRef =
      FirebaseFirestore.instance.collection("NOTIFICATIONS");
  AppDataProvider? _dataProvider;
  List<Map<String, dynamic>> _posts = [];
  List appUsers = [];
  final _pageController = PageController();
  int _notificationsCount = 0;

  Future<void> _getNotificationCount() async {
    await _notificationsRef
        .where('origin_user', isEqualTo: _auth.currentUser!.uid)
        .where('notified', isEqualTo: false)
        .count()
        .get()
        .then((value) {
      if (value != null) {
        _notificationsCount = value.count!;
      }
      setState(() {});
    }).catchError((e) {
      CommonResponses().showToast(e.code, isError: true);
    });
    Future.delayed(const Duration(seconds: 4), () async {
      await _getNotificationCount();
    });
  }

  Future<void> getAllUsers() async {
    var res = await DatabaseServices().retrieveAllUsers();
    print(res);
    if (res['msg'] == 'done') {
      appUsers = res['data'];
    }

    Future.delayed(const Duration(seconds: 1), () async {
      await getAllUsers();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
    _getNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _dataProvider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              CommonResponses().shiftPage(context, const NotificationScreen());
            },
            child: AbsorbPointer(
              child: Stack(
                children: [
                  IconButton(
                      onPressed: () {
                        CommonResponses()
                            .shiftPage(context, const NotificationScreen());
                      },
                      icon: const Icon(Icons.notifications_active)),
                  Positioned(
                    right: 6,
                    top: 3,
                    child: _notificationsCount == 0
                        ? Container(
                            color: blueColor,
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: redColor,
                            child: Text(
                              _notificationsCount.toString(),
                              style: TextStyle(color: whiteColor, fontSize: 12),
                            ),
                          ),
                  )
                ],
              ),
            ),
          )
        ],
        title: _currentPageIndex == 2
            ? Align(
                alignment: Alignment.centerLeft,
                child: StatefulBuilder(builder: (context, stateSetter) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    stateSetter(() {
                      searchWidth = screenSize.width;
                    });
                  });
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    height: 40,
                    width: searchWidth,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        TextFormField(
                          // controller: _singlePeriodAmountCntrl,
                          onChanged: (val) {
                            if (val.trim().isNotEmpty) {
                              something.value = true;
                            } else {
                              filteredUsers.value = [];
                              something.value = false;
                            }
                            if (val.trim().isNotEmpty) {
                              filteredUsers.value = appUsers
                                  .where((el) => (el['first_name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(val.toLowerCase()) ||
                                      el['last_name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(val.toLowerCase()) ||
                                      el['user_name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(val.toLowerCase())))
                                  .toList();
                            }
                          },
                          decoration: InputDecoration(
                              prefix: const Text("       "),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: blackColor),
                                  borderRadius: BorderRadius.circular(50)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              hintText: "Search anyone",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search_outlined))
                      ],
                    ),
                  );
                }),
              )
            : Text(
                "Home",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
        leading: _auth.currentUser == null
            ? IconButton(
                onPressed: () {
                  CommonResponses().shiftPage(context, const SigninScreen());
                },
                icon: Icon(Icons.person))
            : GestureDetector(
                onTap: () {
                  CommonResponses().shiftPage(
                      context, UserScreen(_dataProvider!.currentUser));
                },
                child: AbsorbPointer(
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(left: 6, bottom: 3, top: 3),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: blackColor, blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.circular(40),
                        color: whiteColor),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                          imageUrl:
                              _dataProvider!.currentUser['profile_photo']),
                    ),
                  ),
                ),
              ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: screenSize.height,
          padding: EdgeInsets.only(top: 5),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [HomeTabScreen(), searchTabscreen()],
          )),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: appColor,
        onTap: (index) async {
          print("Index clicked.. ${index}");
          searchWidth = 40;
          if (index == 1) {
            if (_auth.currentUser != null) {
              await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreatePostScreen()))
                  .then((value) async {});
            } else {
              CommonResponses().showToast("Login first please..");
            }
          } else if (index == 0) {
            _currentPageIndex = index;
            _shiftBottomView(0);
          } else {
            _currentPageIndex = index;
            _shiftBottomView(1);
          }
          setState(() {});
        },
        currentIndex: 1,
        selectedLabelStyle: const TextStyle(height: 0.0),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
                width: 70,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(width: 3),
                    borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.add)),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }

  void _shiftBottomView(int i) {
    _pageController.animateToPage(i,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}
