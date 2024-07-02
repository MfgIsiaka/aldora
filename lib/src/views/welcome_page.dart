import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/widgets/authButton.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/icons/hotel.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 100,
            top: 180,
            child: Column(
              children: [
                Text(
                  "Find your best Hotel",
                  style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Let us help you find a best place\nfor you to rest",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 50, // Adjust the position to ensure visibility
            bottom: 50, // Use bottom instead of top for better placement
            child: SizedBox(
              width: MediaQuery.of(context).size.width -
                  100, // Set a fixed width
              child: const CustomRectangularButton(
                text: "Get Started",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
