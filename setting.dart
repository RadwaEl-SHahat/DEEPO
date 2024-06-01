
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ids_deepo/screens/Home.dart';
import 'package:ids_deepo/screens/about.dart';
import 'package:ids_deepo/screens/account.dart';
import 'package:ids_deepo/screens/helpAndSupport.dart';
import 'package:ids_deepo/screens/login.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  // Declare FirebaseAuth instance
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 100.0),
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Oflutter.com'),
              accountEmail: Text('example@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/person.png',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Account()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.question_mark),
              title: Text('About'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => About()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.headphones),
              title: Text('Help & support'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpAndSupport()),
              ),
            ),
            SizedBox(height: 240),
            Divider(),
            ElevatedButton(
              onPressed: () async {
                await signOut(); // Call the signOut method and wait for it to complete
                // Additional logic if needed after sign out
                // For example, navigate to the login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
              child: ListTile(
                title: Text('Sign out'),
                leading: Icon(Icons.exit_to_app),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
