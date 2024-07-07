import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iwm/screens/post_details_screen.dart';
import 'package:iwm/screens/user_screen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _auth = FirebaseAuth.instance;
  bool _loading = true;
  List _notifications = [];
  var response = {};

  Future<void> _getNotifications() async {
    var res = await DatabaseServices().retrieveNotifications();
    response = res;
    if (res['msg'] == 'done' && res['data'].isNotEmpty) {
      _notifications = res['data'];
      _notifications = _notifications
          .where((el) => el['origin_user']['id'] == _auth.currentUser!.uid)
          .toList();
      await _updateNotifiedStatus();
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateNotifiedStatus() async {
    var res = await DatabaseServices().updateNotifiedStatus(_notifications);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : response['msg'] != 'done'
                ? Text(
                    response['msg'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : _notifications.isNotEmpty
                    ? ListView.builder(
                        itemCount: _notifications.length,
                        itemBuilder: (context, ind) {
                          var notif = _notifications[ind];
                          return Container(
                            margin: EdgeInsets.only(top: 3, left: 2, right: 2),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                boxShadow: [
                                  BoxShadow(color: blackColor, blurRadius: 5)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${notif['description']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: appColor),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        CommonResponses().shiftPage(
                                            context, UserScreen(notif['user']));
                                      },
                                      child: AbsorbPointer(
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          margin: const EdgeInsets.only(
                                              left: 6, bottom: 3, top: 3),
                                          decoration: BoxDecoration(
                                              color: Colors.blueGrey,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      "${notif['new_user']['profile_photo']}"))),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            CommonResponses().shiftPage(context,
                                                UserScreen(notif['new_user']));
                                          },
                                          child: AbsorbPointer(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${notif['new_user']['first_name']} ${notif['new_user']['last_name']}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "@${notif['new_user']['user_name']}",
                                                  style: const TextStyle(
                                                      color: Colors.blueGrey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // CommonResponses().shiftPage(
                                                //     context,
                                                //     PostDetailsScreen(
                                                //         post, post['user']));
                                              },
                                              child: AbsorbPointer(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        notif['new_body'],
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            (1 == 1)
                                                ? Container()
                                                : Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          "Taken from ",
                                                          style: TextStyle(
                                                              color: greyColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          "@napten",
                                                          style: TextStyle(
                                                              color: appColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all()),
                                                child:
                                                    Text(notif['origin_body']))
                                          ],
                                        )
                                      ],
                                    ))
                                  ],
                                )
                              ],
                            ),
                          );
                        })
                    : const Text(
                        "No data was found",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
      ),
    );
  }
}
