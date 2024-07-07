import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iwm/screens/homescreen.dart';
import 'package:iwm/services/common_responses.dart';
import 'package:iwm/services/common_variables.dart';
import 'package:iwm/services/database_services.dart';
import 'package:iwm/services/provider_services.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _descController = TextEditingController();
  Map<String, dynamic> _user = {};
  final _auth = FirebaseAuth.instance;

  AppDataProvider? _dataProvider;
  List<File> _imageToUpload = [];
  bool _uploading = false;
  String _creativity = "Not creative";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _dataProvider = Provider.of<AppDataProvider>(context);
    _user = _dataProvider!.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create post"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
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
                    IconButton(
                        onPressed: () async {
                          _imageToUpload =
                              await CommonResponses().getImageFromCamera();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.image_outlined,
                          color: appColor,
                        )),
                    IconButton(
                        onPressed: () async {
                          String description = _descController.text.trim();
                          if (description.isNotEmpty) {
                            setState(() {
                              _uploading = true;
                            });
                            var res = await DatabaseServices().uploadPost({
                              'body': description,
                              'files': _imageToUpload,
                              'comments': 0,
                              'likes': [],
                              'from': "",
                              'reposts': [],
                              'user': _user['id']
                            });
                            setState(() {
                              _uploading = false;
                            });
                            if (res['msg'] == "done") {
                              setState(() {
                                _imageToUpload = [];
                                _descController.clear();
                              });
                              CommonResponses().showToast("Done..");
                              Navigator.pop(context);
                            } else {
                              CommonResponses()
                                  .showToast(res['msg'], isError: true);
                            }
                          } else {
                            CommonResponses().showToast(
                                "Empty post not allowed!!",
                                isError: true);
                          }
                        },
                        style:
                            OutlinedButton.styleFrom(backgroundColor: appColor),
                        icon: _uploading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: whiteColor,
                                ),
                              )
                            : Transform.rotate(
                                angle: (-3.14 / 4),
                                child: Icon(
                                  Icons.send,
                                  color: whiteColor,
                                )))
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _descController,
                        decoration: const InputDecoration(
                            hintText: "Tell the  world..."),
                        maxLines: 100,
                        minLines: 1,
                      ),
                      _imageToUpload.isEmpty
                          ? Container()
                          : Container(
                              color: const Color.fromARGB(122, 96, 125, 139),
                              padding: EdgeInsets.all(5),
                              child: SizedBox(
                                height: 200,
                                child: ListView.builder(
                                    itemCount: _imageToUpload.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, ind) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                            color: redColor,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: blackColor,
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                                _imageToUpload[ind])),
                                      );
                                    }),
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
