import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ids_deepo/home_card.dart';

import 'package:ids_deepo/screens/scan.dart';
import 'package:ids_deepo/screens/setting.dart';
import 'package:ids_deepo/screens/url.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser!;
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Image.asset('assets/logo.png'),
        ),
        title: const Center(child: Text('DEEPO')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 21.0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height:50,),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Scan()));
                  },
                  child: HomeCard(label: "Scan System ",image: 'assets/scan.png',),
                ),
                SizedBox(height: 20,),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => URL()));
                  },
                  child: HomeCard(label: "Scan url",image: 'assets/url.png',),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
