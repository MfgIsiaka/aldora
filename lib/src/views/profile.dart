import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/main.dart';
import 'package:rolanda/src/constants/colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.topCenter,
                height: 140,
                decoration: const BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(90),
                    bottomLeft: Radius.circular(90),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                child: Column(
                  children: [
                    Text(
                      "Isaya Osward",
                      style: GoogleFonts.poppins(
                          color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: AssetImage("assets/icons/profile.jpg"),
                              fit: BoxFit.cover)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [BoxShadow(blurRadius: 5)],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: "Isaya Osward",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_2_outlined,
                        color: lightBlue,
                      )),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "isayaosward@gmail.com",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: lightBlue,
                      )),
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: "+255 755 957 514",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.call_outlined,
                        color: lightBlue,
                      )),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Dodoma, Tanzania",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: lightBlue,
                      )),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "NIDA",
                      hintStyle: GoogleFonts.poppins(
                        color: mediumGray,
                      ),
                      prefixIcon: const Icon(
                        Icons.info_outline,
                        color: lightBlue,
                      )),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  width: screenSize.width,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(whiteColor),
                        backgroundColor: WidgetStatePropertyAll(primaryBlue),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: GoogleFonts.poppins(),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: screenSize.width,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(whiteColor),
                        backgroundColor: WidgetStatePropertyAll(darkBlue),
                      ),
                      child: Text(
                        "Change password",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
