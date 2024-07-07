import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class DatabaseServices {
  final _auth = FirebaseAuth.instance;
  final _usersRef = FirebaseFirestore.instance.collection("USERS");
  final _commentsRef = FirebaseFirestore.instance.collection("COMMENTS");
  final _notificationsRef =
      FirebaseFirestore.instance.collection("NOTIFICATIONS");
  final _followersRef = FirebaseFirestore.instance.collection("FOLLOWERS");
  final _postsRef = FirebaseFirestore.instance.collection("POSTS");
  final _profilesRef = FirebaseStorage.instance.ref("PROFILES");
  final _postFiles = FirebaseStorage.instance.ref("POST FILES");

  Future<Map<String, dynamic>> signUpUser(Map<String, dynamic> userData) async {
    Map<String, dynamic> result = {};
    await _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: userData['password'])
        .then((value) async {
      var userId = value.user!.uid;
      userData['id'] = userId;
      userData['createdAt'] = DateTime.now().millisecondsSinceEpoch;
      await _profilesRef
          .child(userId)
          .putFile(userData['profile_photo'])
          .then((p0) async {
        await p0.ref.getDownloadURL().then((value) async {
          userData['profile_photo'] = value;
          userData.remove('password');
          await _usersRef.doc(userId).set(userData).then((value) async {
            await _auth.currentUser!.sendEmailVerification().then((value) {
              result = {
                'msg': "done",
                "data": "Verify your email to proceed.."
              };
            }).catchError((e) {
              result = {'msg': e.code};
            });
          }).catchError((e) {
            result = {'msg': e.code};
          });
        }).catchError((e) {
          result = {'msg': e.code};
        });
      }).catchError((e) {
        result = {'msg': e.code};
      });
    }).catchError((e) {
      result = {'msg': e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> signInUser(Map<String, dynamic> userData) async {
    Map<String, dynamic> result = {};
    await _auth
        .signInWithEmailAndPassword(
            email: userData['email'], password: userData['password'])
        .then((value) async {
      await _usersRef.doc(value.user!.uid).get().then((value) {
        result = {'msg': "done", "data": value.data()};
      }).catchError((e) {
        result = {'msg': e.code};
      });
    }).catchError((e) {
      result = {'msg': e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> getSingleUser(String uid) async {
    Map<String, dynamic> result = {};
    await _usersRef.doc(uid).get().then((value) {
      if (value.exists) {
        result = {'msg': "done", 'data': value.data()};
      } else {
        result = {'msg': "done", 'data': {}};
      }
    }).catchError((e) {
      result = {'msg': e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> uploadPost(Map<String, dynamic> postData) async {
    Map<String, dynamic> result = {};
    List images = postData['files'];
    postData['id'] = _postsRef.doc().id;
    postData['timestamp'] = DateTime.now().millisecondsSinceEpoch;

    if (images != null) {
      List<String> imagePaths = [];
      for (var image in images) {
        String imgId = _postsRef.doc().id;
        await _postFiles
            .child(postData['id'])
            .child(imgId)
            .putFile(image)
            .then((p0) async {
          await p0.ref.getDownloadURL().then((path) {
            imagePaths.add(path);
          }).catchError((e) {
            result = {"msg": e.toString(), "data": null};
          });
        }).catchError((e) {
          result = {"msg": e.toString(), "data": null};
        });
      }
      postData['files'] = imagePaths;
      result = await _addPostToFirestore(postData);
    } else {
      result = await _addPostToFirestore(postData);
    }
    return result;
  }

  Future<Map<String, dynamic>> _addPostToFirestore(
      Map<String, dynamic> postData) async {
    Map<String, dynamic> result = {};
    await _postsRef.doc(postData['id']).set(postData).then((value) async {
      result = {"msg": 'done', "data": postData};
      ;
    }).catchError((e) {
      result = {"msg": e.toString(), "data": null};
    });
    return result;
  }

  Future<Map<String, dynamic>> retrievePosts() async {
    Map<String, dynamic> result = {};
    List posts = [];
    await _postsRef
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var el in value.docs) {
          var post = el.data();
          await _usersRef.doc(post['user']).get().then((userValue) {
            if (userValue.exists) {
              var user = userValue.data();
              post['user'] = user;
            }
          });
          posts.add(post);
        }
        result = {'msg': 'done', 'data': posts};
      } else {
        result = {'msg': 'done', 'data': []};
      }
    }).catchError((e) {
      result = {'msg': e.code, 'data': []};
    });
    return result;
  }

  Future<Map<String, dynamic>> retrieveComments() async {
    Map<String, dynamic> result = {};
    List comments = [];
    await _commentsRef
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var el in value.docs) {
          var comment = el.data();
          await _usersRef.doc(comment['user']).get().then((userValue) {
            if (userValue.exists) {
              var user = userValue.data();
              comment['user'] = user;
            }
          });
          comments.add(comment);
        }
        result = {'msg': 'done', 'data': comments};
      } else {
        result = {'msg': 'done', 'data': []};
      }
    }).catchError((e) {
      result = {'msg': e.code, 'data': []};
    });
    return result;
  }

  Future<Map<String, dynamic>> uploadComment(
      Map<String, dynamic> comment) async {
    Map<String, dynamic> result = {};
    comment['id'] = _commentsRef.doc().id;
    comment['likes'] = [];
    comment['timestamp'] = DateTime.now().millisecondsSinceEpoch;
    await _commentsRef.doc(comment['id']).set(comment).then((value) async {
      await _postsRef
          .doc(comment['post'])
          .update({'comments': FieldValue.increment(1)}).then((value) {
        result = {'msg': "done", 'data': null};
      }).catchError((e) {
        result = {'msg': e.code, 'data': null};
      });
    }).catchError((e) {
      result = {'msg': e.code, 'data': null};
    });
    return result;
  }

  Future<Map<String, dynamic>> addFollower(var user, cUId) async {
    Map<String, dynamic> result = {};
    List followers = user['followers'];
    await _usersRef.doc(user['id']).update({
      'followers': followers.contains(cUId)
          ? FieldValue.arrayRemove([cUId])
          : FieldValue.arrayUnion([cUId])
    }).then((value) async {
      await _usersRef.doc(cUId).update({
        'following': followers.contains(cUId)
            ? FieldValue.arrayRemove([user['id']])
            : FieldValue.arrayUnion([user['id']])
      }).then((value) async {
        result = {'msg': "done", 'data': null};
      }).catchError((e) {
        result = {'msg': e.code, 'data': null};
      });
    }).catchError((e) {
      result = {'msg': e.code, 'data': null};
    });
    return result;
  }

  Future<Map<String, dynamic>> retrieveNotifications() async {
    Map<String, dynamic> result = {};
    await _notificationsRef
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) async {
      List notifs = [];
      if (value.docs.isNotEmpty) {
        for (var notif in value.docs) {
          var ntf = notif.data();
          await _usersRef.doc(ntf['origin_user']).get().then((ou) async {
            if (ou.exists) {
              ntf['origin_user'] = ou.data();
            }
            await _usersRef.doc(ntf['new_user']).get().then((nu) async {
              if (nu.exists) {
                ntf['new_user'] = nu.data();
              }
            });
          });

          notifs.add(ntf);
        }
        result = {'msg': 'done', 'data': notifs};
      } else {
        result = {'msg': 'done', 'data': []};
      }
    }).catchError((e) {
      result = {'msg': e.toString(), 'data': []};
    });
    return result;
  }

  Future<Map<String, dynamic>> updateNotifiedStatus(List notifications) async {
    Map<String, dynamic> result = {};
    notifications.forEach((notif) async {
      if (notif['notified'] == false) {
        await _notificationsRef.doc(notif['id']).update({'notified': true});
      }
    });

    return result;
  }

  Future<Map<String, dynamic>> retrieveAllUsers() async {
    Map<String, dynamic> result = {};
    await _usersRef.get().then((value) async {
      List users = [];
      if (value.docs.isNotEmpty) {
        for (var notif in value.docs) {
          var ntf = notif.data();
          users.add(ntf);
        }
        result = {'msg': 'done', 'data': users};
      } else {
        result = {'msg': 'done', 'data': []};
      }
    }).catchError((e) {
      result = {'msg': e.toString(), 'data': []};
    });
    return result;
  }
}
