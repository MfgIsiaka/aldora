import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/widgets/authButton.dart';
import 'package:rolanda/src/widgets/bottomAuthNav.dart';
import 'package:rolanda/src/widgets/socialMediaButtons.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 25, right: 25, top: 100),
        child: Column(
          children: [
            Text(
              "Rolanda",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: primaryBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 120,
            ),
            Column(
              children: [
                Text(
                  "Welcome Again",
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Login to continue",
                  style: GoogleFonts.poppins(color: mediumGray),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  enableSuggestions: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      hintText: "Email address",
                      hintStyle: GoogleFonts.poppins(fontSize: 18),
                      suffixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.lightBlue,
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .red, // Change the color for the error state
                          width: 2.0, // Optional: change the border width
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .red, // Change the color for the focused error state
                          width: 2.0, // Optional: change the border width
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryBlue, width: 2)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4))),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      hintText: "Password",
                      hintStyle: GoogleFonts.poppins(),
                      suffixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.lightBlue,
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .red, // Change the color for the error state
                          width: 2.0, // Optional: change the border width
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .red, // Change the color for the focused error state
                          width: 2.0, // Optional: change the border width
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryBlue, width: 2)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot password",
                        textAlign: TextAlign.end,
                        style: GoogleFonts.poppins(
                          color: mediumGray,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomRectangularButton(text: "Login"),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  "Or Sign in With",
                  style: GoogleFonts.poppins(
                    color: mediumGray,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                const SocialMediaButtons(),
                const SizedBox(
                  height: 30,
                ),
                const BottomAuthNav(
                  text: "Don't have an Account ?",
                  link: "Sign Up",
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
