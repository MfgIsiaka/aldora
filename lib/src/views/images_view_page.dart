import 'package:flutter/material.dart';
import 'package:rolanda/src/constants/colors.dart';

class ImagesViewPage extends StatefulWidget {
  const ImagesViewPage({super.key});

  @override
  State<ImagesViewPage> createState() => _ImagesViewPageState();
}

class _ImagesViewPageState extends State<ImagesViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: PageView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/hotel_images/${index + 1}.jpg"),
                        fit: BoxFit.fitWidth)),
              );
            }),
      ),
    );
  }
}
