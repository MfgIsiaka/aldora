import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/main.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  Future<void> _completeWelcome(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Rolanda(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //hiding the system UI overlays
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/icons/hotel.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
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
              width:
                  MediaQuery.of(context).size.width - 100, // Set a fixed width
              child: GestureDetector(
                onTap: () => _completeWelcome(context),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      "Get Started",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: whiteColor),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
