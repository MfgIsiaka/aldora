import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class CommonResponses {
  final _postsRef = FirebaseFirestore.instance.collection("POSTS");
  final _auth = FirebaseAuth.instance;
  // shiftPageView(int page) {
  //   controller.animateToPage(page,
  //       duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  // }

  bool _isSending = false;
  showRepostConfirmBox(BuildContext context, var post) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, stateSetter) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Repost?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: appColor,
                          foregroundColor: whiteColor),
                      onPressed: _isSending
                          ? null
                          : () async {
                              stateSetter(() {
                                _isSending = true;
                              });
                              var newPost = post;
                              newPost['from'] = post['id'];
                              newPost['user'] = post['user']['id'];
                              newPost['likes'] = [];
                              newPost['timestamp'] =
                                  DateTime.now().millisecondsSinceEpoch;
                              var id = _postsRef.doc().id;
                              newPost['id'] = id;
                              await _postsRef
                                  .doc(id)
                                  .set(newPost)
                                  .then((value) async {
                                await _postsRef.doc(post['id']).update({
                                  'reposts': FieldValue.arrayUnion(
                                      [_auth.currentUser!.uid])
                                }).then((value) {
                                  stateSetter(() {
                                    _isSending = false;
                                  });
                                  showToast("Reposted..");
                                  Navigator.pop(context);
                                }).catchError((e) {
                                  stateSetter(() {
                                    _isSending = false;
                                  });
                                  showToast(e.code, isError: true);
                                });
                              }).catchError((e) {
                                stateSetter(() {
                                  _isSending = false;
                                });
                                showToast(e.code, isError: true);
                              });
                              // {comments: 1, files: [], id: 6wrP4C76HMj49fpRR4NX, user: yaSdw5AyKtTBK5kLLwYTmmc2F7K2, reposts: []}
                            },
                      child: _isSending
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator())
                          : Text("Send"))
                ],
              ),
            );
          });
        });
  }

  showToast(String msg, {bool? isError}) {
    Fluttertoast.showToast(
        msg: msg, backgroundColor: isError == true ? redColor : greenColor);
  }

  shiftPage(BuildContext context, Widget wid, {bool? kill}) {
    if (kill == true) {
      Navigator.pushAndRemoveUntil(context,
          PageTransition(child: wid, type: PageTransitionType.rightToLeft),
          (co) {
        return false;
      });
    } else {
      Navigator.push(context,
          PageTransition(child: wid, type: PageTransitionType.rightToLeft));
    }
  }

  Future<List<File>> getImageFromCamera() async {
    List<File> result = [];
    final res = await ImagePicker().pickMultiImage(imageQuality: 20);
    if (res != null) {
      for (var el in res) {
        var cFile = await compressImage(File(el.path));
        if (cFile != null) {
          File fl = File(el.path);
          result.add(await fl.writeAsBytes(cFile));
        }
      }
    }
    return result;
  }

  Future<Uint8List?> compressImage(File fileToCompress) async {
    var result = await FlutterImageCompress.compressWithFile(
        fileToCompress.path,
        quality: 20);
    return result;
  }

  String formatTimeDifference(DateTime dateTime) {
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

  showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: SizedBox(
                width: 50,
                height: 50,
                child: CircleAvatar(
                  child: CircularProgressIndicator(),
                )),
          );
        });
  }
}
