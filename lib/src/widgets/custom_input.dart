import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController inputController;
  final keyboardType;
  final bool obscureText;
  final icon;
  final String labelText;
  const CustomInput(
      {super.key,
      required this.inputController,
      required this.obscureText,
      required this.keyboardType,
      required this.labelText,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: GoogleFonts.poppins(),
      controller: inputController,
      decoration: InputDecoration(
          label: Text(labelText),
          labelStyle: GoogleFonts.poppins(fontSize: 18),
          suffixIcon: Icon(
            icon,
            color: Colors.lightBlue,
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red, // Change the color for the error state
              width: 2.0, // Optional: change the border width
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red, // Change the color for the focused error state
              width: 2.0, // Optional: change the border width
            ),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryBlue, width: 2)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          border: OutlineInputBorder()),
    );
  }
}
