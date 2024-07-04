import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolanda/src/constants/colors.dart';
import 'package:rolanda/src/widgets/phone_number_widget.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  void _toBackPage(BuildContext context) {
    Navigator.pop((context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 30,
          right: 40,
          top: 10,
          bottom: 50,
        ),
        child: Column(
          children: [
            RichText(
              text: TextSpan(children: [
                normalSpan('Welcome at '),
                const TextSpan(
                    text: 'Rolanda \n',
                    style: TextStyle(
                        color: primaryBlue, fontWeight: FontWeight.bold)),
                normalSpan('At '),
                const TextSpan(
                    text: 'Rolanda, ',
                    style: TextStyle(
                        color: primaryBlue, fontWeight: FontWeight.bold)),
                normalSpan(
                    ' we strive to make sure your accomodation booking booking experience and enjoyable wether you\'re looking for a hotel, lodge, or apartment. Our app provides you with a comprehensive and user-friendly platform to find and book your ideal stay. '),
                headerSpan("Our Mission"),
                normalSpan(
                    "Our mission is to connect travelers with the best accomodation options while ensuring a smooth and secure booking process Our mission is to connect travelers with the best accomodation options while ensuring a smooth and secure booking process Our mission is to connect travelers with the best accomodation options while ensuring a smooth and secure booking process"),
                headerSpan("What We Offer"),
                _buildBulletPoint("Wide Selection"),
                _buildBulletPoint("Easy Booking."),
                _buildBulletPoint("Secure Payments"),
              ], style: GoogleFonts.poppins(color: blackColor)),
            ),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get in touch with us via",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: getInTouchRow(
                          Icons.call_outlined,
                          const PhoneNumberWidget(
                              phoneNumber: "+255 755 957 514")),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: getInTouchRow(
                        Icons.language_outlined,
                        Text(
                          "www.rolanda.co.tz",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: getInTouchRow(
                        Icons.email_outlined,
                        Text(
                          "rolanda@mail.com",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: GestureDetector(
                onTap: () => _toBackPage(context),
                child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Go back",
                      style: GoogleFonts.poppins(
                        color: whiteColor,
                        fontSize: 18,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row getInTouchRow(IconData icon, Widget widget) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryBlue,
        ),
        const SizedBox(
          width: 10,
        ),
        widget,
      ],
    );
  }

  TextSpan headerSpan(String text) {
    return TextSpan(
      text: "\n\n$text\n",
      style: const TextStyle(
        color: darkBlue,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  TextSpan normalSpan(String text) {
    return TextSpan(
      text: text,
    );
  }

  TextSpan _buildBulletPoint(String text) {
    return TextSpan(
      children: [
        const WidgetSpan(
          child: Text('   • ',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
        ),
        TextSpan(
          text: '$text\n',
        ),
      ],
    );
  }
}
