import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/base_styles.dart';
import 'package:rolanda/src/constants/colors.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
            icon: Image.asset(
              "assets/icons/google.png",
              width: 30,
            ),
            label:
                Text("Google", style: baseTxtStyle.copyWith(color: lightBlue))),
        ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
            icon: Image.asset(
              "assets/icons/facebook.png",
              color: darkBlue,
              width: 30,
            ),
            label:
                Text("Google", style: baseTxtStyle.copyWith(color: lightBlue))),
      ],
    );
  }
}
