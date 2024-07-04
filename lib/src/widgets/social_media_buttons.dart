import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(-5, 5), // Shadow on left (-5) and bottom (5)
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/icons/google.png",
                width: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Google",
                style: GoogleFonts.poppins(color: darkBlue, fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: BoxDecoration(
            color: darkBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(-5, 5), // Shadow on left (-5) and bottom (5)
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/icons/facebook.png",
                width: 30,
                color: whiteColor,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Facebook",
                style: GoogleFonts.poppins(color: whiteColor),
              )
            ],
          ),
        )
      ],
    );
  }
}
