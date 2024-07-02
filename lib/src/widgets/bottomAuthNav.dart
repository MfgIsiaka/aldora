import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';

class BottomAuthNav extends StatelessWidget {
  final text, link;
  const BottomAuthNav({
    super.key,
    required this.text,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            color: mediumGray,
            fontSize: 18,
          ),
        ),
        Text(
          link,
          style: GoogleFonts.poppins(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
