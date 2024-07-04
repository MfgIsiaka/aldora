import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/views/about_us.dart';
import 'package:rolanda/src/widgets/auth_button.dart';

class ContactUs extends StatelessWidget {
  ContactUs({super.key});
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  void _toAboutPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AboutUs()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 25, right: 25, top: 66),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text(
              "Contact us now",
              style: GoogleFonts.poppins(
                color: darkBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your email",
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                      hintText: "name@mail.com",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryBlue,
                          width: 2,
                        ),
                      ),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: mediumGray,
                      ))),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Subject",
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: "let us know how we can help you",
                    hintStyle: GoogleFonts.poppins(
                      color: mediumGray,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryBlue,
                        width: 2,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: mediumGray),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your message",
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  style: GoogleFonts.poppins(),
                  maxLines: 10,
                  maxLength: 500,
                  decoration: InputDecoration(
                      hintText: "Leave your message here",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryBlue,
                          width: 2,
                        ),
                      ),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: mediumGray,
                      ))),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomRectangularButton(text: "Send message"),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () => _toAboutPage(context),
              child: Text(
                "See all about us",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
