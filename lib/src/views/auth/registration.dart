import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/widgets/authButton.dart';
import 'package:rolanda/src/widgets/bottomAuthNav.dart';
import 'package:rolanda/src/widgets/custom_input.dart';
import 'package:rolanda/src/widgets/socialMediaButtons.dart';

class Registration extends StatelessWidget {
  Registration({super.key});
  final usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Text(
            "Rolanda",
            style: GoogleFonts.poppins(
                color: primaryBlue, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            "Create an Account",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: darkBlue,
              fontSize: 20,
            ),
          ),
          Text(
            "Fill your details below",
            style: GoogleFonts.poppins(
              color: mediumGray,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomInput(
            icon: Icons.person_2_outlined,
            obscureText: false,
            labelText: "Username",
            keyboardType: "text",
            inputController: usernameController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            icon: Icons.person_2_outlined,
            obscureText: false,
            labelText: "Email address",
            keyboardType: "email",
            inputController: usernameController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            icon: Icons.co_present_rounded,
            obscureText: false,
            labelText: "Your NIDA",
            keyboardType: "number",
            inputController: usernameController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            icon: Icons.call_outlined,
            obscureText: false,
            labelText: "Phone number",
            keyboardType: "phone",
            inputController: usernameController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            obscureText: true,
            labelText: "Password",
            keyboardType: "password",
            inputController: usernameController,
          ),
          const SizedBox(
            height: 20,
          ),
          const CustomRectangularButton(text: "Register"),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Or continue with",
            style: GoogleFonts.poppins(color: mediumGray),
          ),
          const SizedBox(
            height: 20,
          ),
          const SocialMediaButtons(),
          const SizedBox(
            height: 20,
          ),
          const BottomAuthNav(text: "Already have an Account", link: "Sign In")
        ],
      )),
    );
  }
}
