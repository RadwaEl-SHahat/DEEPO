import 'package:flutter/material.dart';
import 'package:ids_deepo/screens/setting.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'About',
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

              children:[Text(
                'About info:',
               style: GoogleFonts.robotoCondensed(
              fontSize: 17,
              ),
            ),
            SizedBox(height :10),
            Text('App Version:',
              style: GoogleFonts.robotoCondensed(
                fontSize: 15,
            ),),
                SizedBox(height :5),
              Text('1.0.1',
                style: GoogleFonts.robotoCondensed(
                  fontSize: 13,
                  color:Colors.indigo
                ),),
        ],),
      ),


    );
  }
}
