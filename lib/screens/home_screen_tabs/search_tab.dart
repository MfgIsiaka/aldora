import 'package:flutter/material.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:iwm/screens/user_screen.dart';
import 'package:iwm/services/common_responses.dart';

class searchTabscreen extends StatefulWidget {
  const searchTabscreen({super.key});

  @override
  State<searchTabscreen> createState() => _searchTabscreenState();
}

class _searchTabscreenState extends State<searchTabscreen> {
  List _users = [];
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ValueListenableBuilder(
            valueListenable: filteredUsers,
            builder: (context, users, child) {
              return users.isNotEmpty
                  ? ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, ind) {
                        var user = users[ind];
                        return ListTile(
                          onTap: () {
                            CommonResponses()
                                .shiftPage(context, UserScreen(user));
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.only(
                                left: 6, bottom: 3, top: 3),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        "${user['profile_photo']}"))),
                          ),
                          title: Text(
                              "${user['first_name']} ${user['last_name']}"),
                          subtitle: Text("@${user['user_name']}"),
                        );
                      })
                  : const Text("Type something");
            }));
  }
}
