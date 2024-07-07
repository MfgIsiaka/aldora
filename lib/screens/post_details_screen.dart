import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iwm/screens/user_screen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';

class PostDetailsScreen extends StatefulWidget {
  var post, user;
  PostDetailsScreen(this.post, this.user, {super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final _auth = FirebaseAuth.instance;
  final _commentsRef = FirebaseFirestore.instance.collection("COMMENTS");
  final _usersRef = FirebaseFirestore.instance.collection("USERS");
  final _commentController = TextEditingController();
  final _postsRef = FirebaseFirestore.instance.collection("POSTS");
  bool _loading = true;
  var _commentsResponse = {};
  List _comments = [];
  bool _uploadingComment = false;
  var _post, _user;
  List _files = [];

  Future<void> _getComments() async {
    var response = await DatabaseServices().retrieveComments();
    _loading = false;
    _commentsResponse = response;
    if (response['msg'] == "done") {
      _comments = response['data'];
      if (_comments.isNotEmpty) {
        _comments = _comments.where((el) => el['post'] == _post['id']).toList();
      }
    }
    setState(() {});
    Future.delayed(const Duration(milliseconds: 200), () async {
      print("KKKK");
      await _getComments();
    });
  }

  Future<void> _getPost() async {
    var response = await DatabaseServices().retrievePosts();
    if (response['msg'] == "done") {
      List psts = response['data'];
      if (psts.isNotEmpty) {
        _post = psts.where((el) => el['id'] == _post['id']).toList()[0];
        _user = _post['user'];
      }
    }
    setState(() {});
    Future.delayed(const Duration(milliseconds: 200), () async {
      await _getPost();
    });
  }

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _post = widget.post;
    _files = _post['files'];
    _getComments();
    _getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                CommonResponses()
                                    .shiftPage(context, UserScreen(_user));
                              },
                              child: AbsorbPointer(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.only(
                                      left: 6, bottom: 3, top: 3),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "${_user['profile_photo']}"))),
                                ),
                              ),
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
                                        margin: const EdgeInsets.only(left: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 7),
                                        decoration: BoxDecoration(
                                            color: _user['followers'].contains(
                                                    _auth.currentUser!.uid)
                                                ? Colors.grey
                                                : appColor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                                  )
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                CommonResponses()
                                    .shiftPage(context, UserScreen(_user));
                              },
                              child: AbsorbPointer(
                                child: Row(
                                  children: [
                                    Text(
                                      "${_user['first_name']} ${_user['last_name']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "@${_user['user_name']}",
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Time",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _post['body'],
                                  style: const TextStyle(fontSize: 15),
                                ),
                                _files.isEmpty
                                    ? Container()
                                    : Container(
                                        child: Row(
                                          children: _files
                                              .map((e) => Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.network(
                                                            "${e}"),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
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
                                          await _likePost(_post);
                                        },
                                        child: AbsorbPointer(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _post['likes'].contains(
                                                      _auth.currentUser!.uid)
                                                  ? Icon(
                                                      Icons.favorite_rounded,
                                                      color: redColor,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .favorite_outline_rounded,
                                                    ),
                                              Text("${_post['likes'].length}")
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _addCommentDialog(_post);
                                        },
                                        child: AbsorbPointer(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.message_outlined),
                                              Text("${_post['comments']}")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.refresh_rounded),
                                          Text("0")
                                        ],
                                      ),
                                      Icon(Icons.share)
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                  Text(
                    "Comments(${_comments.length})",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _loading == false
                      ? _commentsResponse['msg'] == "done"
                          ? _comments.isNotEmpty
                              ? Column(
                                  children: _comments.map((comment) {
                                    String time = _formatTimeDifference(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            comment['timestamp']));
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey))),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  CommonResponses().shiftPage(
                                                      context,
                                                      UserScreen(_user));
                                                },
                                                child: AbsorbPointer(
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    margin: EdgeInsets.only(
                                                        left: 6,
                                                        bottom: 3,
                                                        top: 3),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blueGrey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                comment['user'][
                                                                    'profile_photo']))),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  comment['likes'].contains(
                                                          _auth
                                                              .currentUser!.uid)
                                                      ? Icon(
                                                          Icons
                                                              .favorite_rounded,
                                                          color: redColor,
                                                          size: 14,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .favorite_outline,
                                                          size: 14,
                                                        ),
                                                  Text(
                                                    "${comment['likes'].length}",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
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
                                                      UserScreen(_user));
                                                },
                                                child: AbsorbPointer(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "${comment['user']['first_name']} ${comment['user']['last_name']}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "${comment['user']['user_name']}",
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .blueGrey),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        "${time}",
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _likeComment(comment);
                                                },
                                                child: AbsorbPointer(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Text(
                                                        "${comment['body']}",
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                              _commentsResponse['msg'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                      : const CircularProgressIndicator()
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(
            Icons.add,
            color: whiteColor,
          ),
          backgroundColor: appColor,
          onPressed: () {
            _addCommentDialog(_post);
          }),
    );
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

  String _formatTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} d';
    } else if (difference.inDays < 365) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks w';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years y';
    }
  }

  _likeComment(comment) async {
    await _commentsRef.doc(comment['id']).update({
      'likes': comment['likes'].contains(_auth.currentUser!.uid)
          ? FieldValue.arrayRemove([_auth.currentUser!.uid])
          : FieldValue.arrayUnion([_auth.currentUser!.uid])
    }).then((value) {
      CommonResponses().showToast("Done..");
    }).catchError((e) {
      CommonResponses().showToast(e.toString(), isError: true);
    });
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
}
