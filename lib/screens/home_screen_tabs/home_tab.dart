import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iwm/screens/post_details_screen.dart';
import 'package:iwm/screens/user_screen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';

List _posts = [];

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final _postsRef = FirebaseFirestore.instance.collection("POSTS");
  final _auth = FirebaseAuth.instance;
  bool _loading = true;
  var _postsResponse = {};

  Future<void> _getPosts() async {
    var response = await DatabaseServices().retrievePosts();
    _loading = false;
    _postsResponse = response;
    if (response['msg'] == "done") {
      _posts = response['data'];
    }
    setState(() {});
    Future.delayed(const Duration(milliseconds: 200), () async {
      print("KKKK");
      await _getPosts();
    });
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _loading == false
            ? _postsResponse['msg'] == "done"
                ? _posts.isNotEmpty
                    ? ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (context, ind) {
                          var post = _posts[ind];
                          String time = CommonResponses().formatTimeDifference(
                              DateTime.fromMillisecondsSinceEpoch(
                                  post['timestamp']));
                          List files = post['files'];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    CommonResponses().shiftPage(
                                        context, UserScreen(post['user']));
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
                                                  "${post['user']['profile_photo']}"))),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        CommonResponses().shiftPage(
                                            context, UserScreen(post['user']));
                                      },
                                      child: AbsorbPointer(
                                        child: Row(
                                          children: [
                                            Text(
                                              "${post['user']['first_name']} ${post['user']['last_name']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "@${post['user']['user_name']}",
                                              style: const TextStyle(
                                                  color: Colors.blueGrey),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${time}",
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            )
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
                                            CommonResponses().shiftPage(
                                                context,
                                                PostDetailsScreen(
                                                    post, post['user']));
                                          },
                                          child: AbsorbPointer(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    post['body'],
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  files.isEmpty
                                                      ? Container()
                                                      : Row(
                                                          children: [0]
                                                              .map(
                                                                  (e) =>
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              right: 5),
                                                                          decoration:
                                                                              BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            child:
                                                                                Image.network(
                                                                              "${post['files'][e]}",
                                                                              errorBuilder: (context, a, b) {
                                                                                return const Text("Error");
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ))
                                                              .toList(),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        (1 == 1)
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      "Taken from ",
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "@napten",
                                                      style: TextStyle(
                                                          color: appColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Color.fromARGB(
                                                          45, 0, 0, 0)))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await _likePost(post);
                                                },
                                                child: AbsorbPointer(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      post['likes'].contains(
                                                              _auth.currentUser!
                                                                  .uid)
                                                          ? Icon(
                                                              Icons
                                                                  .favorite_rounded,
                                                              color: redColor,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .favorite_outline_rounded,
                                                            ),
                                                      Text(
                                                          "${post['likes'].length}")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _addCommentDialog(post);
                                                },
                                                child: AbsorbPointer(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons
                                                          .message_outlined),
                                                      Text(
                                                          "${post['comments']}")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (post['reposts'].contains(
                                                          _auth.currentUser!
                                                              .uid) ==
                                                      false) {
                                                    CommonResponses()
                                                        .showRepostConfirmBox(
                                                            context, post);
                                                  } else {
                                                    CommonResponses().showToast(
                                                        "Already reposted by you");
                                                  }
                                                },
                                                child: AbsorbPointer(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(Icons
                                                          .refresh_rounded),
                                                      Text(post['reposts']
                                                          .length
                                                          .toString())
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () async {},
                                                  child: const AbsorbPointer(
                                                      child: Icon(Icons.share)))
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                          );
                        })
                    : const Text(
                        "No data was found",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                : Text(
                    _postsResponse['msg'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
            : const CircularProgressIndicator());
  }

  _likePost(post) async {
    await _postsRef.doc(post['id']).update({
      'likes': post['likes'].contains(_auth.currentUser!.uid)
          ? FieldValue.arrayRemove([_auth.currentUser!.uid])
          : FieldValue.arrayUnion([_auth.currentUser!.uid])
    }).then((value) {
      CommonResponses().showToast("Done..");
    }).catchError((e) {
      CommonResponses().showToast(e.toString(), isError: true);
    });
  }

  final _commentTxtController = TextEditingController();
  bool _isSending = false;
  void _addCommentDialog(post) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, stateSetter) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add your comment",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextField(
                      controller: _commentTxtController,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          label: Text("Type your comment here "),
                          border: OutlineInputBorder()),
                      maxLines: 50,
                      minLines: 1,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: appColor,
                            foregroundColor: whiteColor),
                        onPressed: _isSending
                            ? null
                            : () async {
                                String commentMsg =
                                    _commentTxtController.text.trim();
                                if (commentMsg.isNotEmpty) {
                                  var comment = {
                                    'body': commentMsg,
                                    'post': post['id'],
                                    'user': _auth.currentUser!.uid
                                  };
                                  stateSetter(() {
                                    _isSending = true;
                                  });
                                  var res = await DatabaseServices()
                                      .uploadComment(comment);
                                  stateSetter(() {
                                    _isSending = false;
                                  });
                                  if (res['msg'] == "done") {
                                    _commentTxtController.clear();
                                    CommonResponses().showToast("Done..");
                                    Future.delayed(Duration(seconds: 1), () {
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    CommonResponses()
                                        .showToast(res['msg'], isError: true);
                                  }
                                } else {
                                  CommonResponses().showToast(
                                      "Type something..",
                                      isError: true);
                                }
                              },
                        child: _isSending
                            ? SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator())
                            : Text("Send"))
                  ],
                ),
              ),
            );
          });
        });
  }
}
