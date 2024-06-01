import 'package:flutter/material.dart';
import 'package:ids_deepo/screens/Home.dart';
import 'package:google_fonts/google_fonts.dart';

class URL extends StatefulWidget {
  const URL({super.key});

  @override
  State<URL> createState() => _URLState();
}

class _URLState extends State<URL> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Scan URL',
          style: GoogleFonts.robotoCondensed(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Image.asset('assets/logo.png', height: 60, width: 60),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 130.0,right: 30,left:30),

          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image
                Image.asset(
                  'assets/url1.png',
                  height: 230,
                ),

                Center(
                  child: Text(
                    'Enter the URL',
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //controller: creditCardController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.http),
                    hintText: 'Credit card number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.indigo),
                    ),
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

