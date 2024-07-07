import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iwm/screens/auth_screens/signin_screen.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:iwm/screens/post_details_screen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  var user;
  UserScreen(this.user, {super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  AppDataProvider? _dataProvider;
  var _user = {};
  List _userPosts = [];
  final _postsRef = FirebaseFirestore.instance.collection("POSTS");
  final _auth = FirebaseAuth.instance;
  bool _loading = true;
  var _postsResponse = {};

  Future<void> _getThisUser() async {
    var response = await DatabaseServices().getSingleUser(_user['id']);
    if (response['msg'] == 'done') {
      setState(() {
        _user = response['data'];
      });
      //CommonResponses().showToast(_user.toString());
    }
    Future.delayed(Duration(seconds: 1), () async {
      _getThisUser();
    });
  }

  Future<void> _getPosts() async {
    var response = await DatabaseServices().retrievePosts();
    _loading = false;
    _postsResponse = response;
    if (response['msg'] == "done") {
      _userPosts = response['data'];
      _userPosts = _userPosts
          .where((el) => el['user']['id'] == _auth.currentUser!.uid)
          .toList();
    }
    setState(() {});
    Future.delayed(const Duration(milliseconds: 200), () async {
      await _getPosts();
    });
  }

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _getThisUser();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    _dataProvider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          _auth.currentUser!.uid != _user['id']
              ? Container()
              : IconButton(
                  onPressed: () async {
                    _showLogoutConfirmDialog();
                  },
                  icon: Icon(Icons.logout))
        ],
        title: Text("${_user['first_name']} ${_user['last_name']}"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      margin: const EdgeInsets.only(left: 6, bottom: 3, top: 3),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: blackColor, blurRadius: 10)
                          ],
                          borderRadius: BorderRadius.circular(40),
                          color: whiteColor),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: CachedNetworkImage(
                            imageUrl: _user['profile_photo']),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Text("Followers"),
                                Text(
                                  "${_user['followers'].length}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Text("Following"),
                                Text(
                                  "${_user['following'].length}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            )),
                          ],
                        ),
                        _user['id'] == _auth.currentUser!.uid
                            ? Container()
                            : GestureDetector(
                                onTap: () async {
                                  var res = await DatabaseServices()
                                      .addFollower(
                                          _user, _auth.currentUser!.uid);
                                  if (res['msg'] == 'done') {
                                    CommonResponses().showToast(res['msg']);
                                  }
                                },
                                child: AbsorbPointer(
                                  child: Container(
                                    width: _size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                        color: _user['followers'].contains(
                                                _auth.currentUser!.uid)
                                            ? Colors.grey
                                            : appColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: Text(
                                        _user['followers'].contains(
                                                _auth.currentUser!.uid)
                                            ? 'Unfollow'
                                            : "Follow",
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("@${_user['user_name']}"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bio: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            "${_user['bio']}",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  "Posts",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              _loading == false
                  ? _postsResponse['msg'] == "done"
                      ? _userPosts.isNotEmpty
                          ? Column(
                              children: _userPosts.map((post) {
                                String time = CommonResponses()
                                    .formatTimeDifference(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            post['timestamp']));
                                List files = post['files'];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          CommonResponses().shiftPage(context,
                                              UserScreen(post['user']));
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              CommonResponses().shiftPage(
                                                  context,
                                                  UserScreen(post['user']));
                                            },
                                            child: AbsorbPointer(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${post['user']['first_name']} ${post['user']['last_name']}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          post['body'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                        files.isEmpty
                                                            ? Container()
                                                            : Row(
                                                                children: [0]
                                                                    .map((e) =>
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                const EdgeInsets.only(right: 5),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              child: Image.network(
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3),
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                            "Taken from ",
                                                            style: TextStyle(
                                                                color:
                                                                    greyColor,
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
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    45,
                                                                    0,
                                                                    0,
                                                                    0)))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                                    _auth
                                                                        .currentUser!
                                                                        .uid)
                                                                ? Icon(
                                                                    Icons
                                                                        .favorite_rounded,
                                                                    color:
                                                                        redColor,
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
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons
                                                            .refresh_rounded),
                                                        Text("0")
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                        onTap: () async {},
                                                        child: AbsorbPointer(
                                                            child: Icon(
                                                                Icons.share)))
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
                              }).toList(),
                            )
                          : const Text(
                              "No data was found",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                      : Text(
                          _postsResponse['msg'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                  : const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
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

  void _showLogoutConfirmDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "logout_confirm",
        transitionDuration: Duration(seconds: 1),
        transitionBuilder: (context, anim1, anim2, child) {
          Animation<Offset> animation = Tween<Offset>(
                  begin: Offset(0, -(anim1.value * 0.4)), end: Offset(0, 0))
              .animate(anim1);
          return SlideTransition(
            position: animation,
            child: child,
          );
        },
        pageBuilder: (context, anim1, anim2) {
          return AlertDialog(
            title: Text("Confirm"),
            content: Text(
                "Dear ${_dataProvider!.currentUser['first_name']}, Are you sure you want to logout?"),
            actions: [
              FilledButton.icon(
                  onPressed: () async {
                    CommonResponses().showLoadingDialog(context);
                    await _auth.signOut().then((value) {
                      _dataProvider!.currentUser = {};
                      CommonResponses()
                          .shiftPage(context, SigninScreen(), kill: true);
                    });
                  },
                  icon: Icon(Icons.thumb_up),
                  label: Text("Yes")),
              FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.back_hand),
                  label: Text("No"))
            ],
          );
        });
  }
}
