import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 100, left: 30),
            child: Text("Rolanda",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: primaryBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text("Welcome Again"),
          const Text("Login to continue"),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "Email address",
                  suffixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.lightBlue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.lightBlue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Forgot password",
                textAlign: TextAlign.end,
                style: GoogleFonts.poppins(
                  color: mediumGray,
                  fontSize: 18,
                ),
              )),
          ElevatedButton(
              style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 25, horizontal: 190)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  backgroundColor: const WidgetStatePropertyAll(primaryBlue)),
              onPressed: () {},
              child: Text(
                "Login",
                style: GoogleFonts.poppins(),
              )),
          SizedBox(
            height: 15,
          ),
          Text(
            "Or Sign in With",
            style: GoogleFonts.poppins(
              color: mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}
