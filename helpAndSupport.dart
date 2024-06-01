import 'package:flutter/material.dart';
import 'package:ids_deepo/screens/feedback.dart';
import 'package:ids_deepo/screens/setting.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        leadingWidth: 70,
        title: Text(
          'Help & Support',
          style: GoogleFonts.robotoCondensed(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Image.asset('assets/logo.png', height: 60, width: 60),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
                ListTile(
                  leading: Icon(Icons.call),
                  title: Text('Call us'),
                  subtitle: Text('19920'),
                ),
                ListTile(
                  leading: Icon(Icons.send_outlined),
                  title: Text('Send Feedback'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen())),
                ),
                ListTile(
                  leading: Icon(Icons.star_rate_outlined),
                  title: Text('Rate the App'),
                  onTap: () => null,
                ),
          ],
        ),
      ),
    );
  }
}
