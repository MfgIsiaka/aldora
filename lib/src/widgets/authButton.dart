import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';

class CustomRectangularButton extends StatelessWidget {
  final text;
  const CustomRectangularButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: primaryBlue, borderRadius: BorderRadius.circular(4)),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: whiteColor),
          )),
    );
  }
}
