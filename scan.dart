import 'package:flutter/material.dart';
import 'package:ids_deepo/screens/Home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ids_deepo/screens/mobile%20analysis.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),

        title: Text(
          'Scan System',
          style: GoogleFonts.robotoCondensed(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Image.asset('assets/logo.png', height: 60, width: 60),
        ],
        ),

      body:
      SafeArea(
        child:Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0,),
              child: Text('DEEPO',style: GoogleFonts.robotoCondensed(color: Colors.black,
                fontSize:35,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),

          InkWell(onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  MobileAnalysisPage()));
          },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.indigo,
                  child: Text('SCAN',
                  style: GoogleFonts.robotoCondensed(color: Colors.white,
                    fontSize:30,
                      fontWeight: FontWeight.bold,

                ),
                    )
                ),
              )
            ),
          ),



          ],

        ),
      ),
    );
  }
}