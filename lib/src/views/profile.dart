import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.topCenter,
              height: 180,
              decoration: const BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(150),
                  bottomLeft: Radius.circular(150),
                ),
              ),
              child: Text(
                "Isaya Osward",
                style: GoogleFonts.poppins(
                    color: whiteColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Positioned(
            top: 80,
            left: 165,
            child: CircleAvatar(
              backgroundColor: darkBlue,
              radius: 77,
              child: CircleAvatar(
                radius: 74,
                backgroundImage: AssetImage("assets/icons/user.png"),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 250, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "Full Name",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_2_outlined,
                        color: lightBlue,
                      )),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "isayaosward@gmail.com",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: lightBlue,
                      )),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "+255 755 957 514",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.call_outlined,
                        color: lightBlue,
                      )),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "Dodoma, Tanzania",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: lightBlue,
                      )),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "NIDA",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.info_outline,
                        color: lightBlue,
                      )),
                ),
                const Divider(),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 15, horizontal: 170)),
                      foregroundColor: WidgetStatePropertyAll(whiteColor),
                      backgroundColor: WidgetStatePropertyAll(primaryBlue),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.poppins(),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 15, horizontal: 145)),
                      foregroundColor: WidgetStatePropertyAll(whiteColor),
                      backgroundColor: WidgetStatePropertyAll(darkBlue),
                    ),
                    child: Text(
                      "Change password",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
