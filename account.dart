import 'package:flutter/material.dart';
import 'package:ids_deepo/screens/changePassword.dart';
import 'package:ids_deepo/screens/setting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ids_deepo/screens/login.dart'; // Import your login screen

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User? user = FirebaseAuth.instance.currentUser;

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
          'Account',
          style: GoogleFonts.robotoCondensed(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Image.asset('assets/logo.png', height: 60, width: 60),
        ],
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/person.png',
                      width: 150,
                      height: 150,
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.indigoAccent,
                      ),
                      child: Text('Upload Photo'),
                    )
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left:20.0),
            child: ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0),
            child: ListTile(
              leading: Icon(Icons.delete_forever_outlined),
              title: Text('Delete Account'),
              onTap: () => _showDeleteConfirmationDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text("Are you sure you want to delete your account?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await user?.delete();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your login screen widget
                  );
                } catch (error) {
                  // Handle any errors that occur during account deletion
                  print("Error deleting account: $error");
                  // You can display an error message to the user if necessary
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

