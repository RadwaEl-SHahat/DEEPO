import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MailForReset extends StatefulWidget {
  @override
  State<MailForReset> createState() => _MailForResetState();
}

class _MailForResetState extends State<MailForReset> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('Reset Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            height: 160,
          ),
          Text('Reset Password', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: 'Enter your Email',
                        labelText: 'Email',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 35),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendVerificationEmail(emailController.text);
        },
        child: Icon(Icons.email),
      ),
    );
  }
  void sendVerificationEmail(String email) async {
    if (!isValidEmail(email)) {
      Fluttertoast.showToast(
        msg: "Incorrect email, please enter a valid email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return; // Exit the function early if email is not valid
    }

    try {
      User? user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email).then((value) {
        if (value.isEmpty) {
          Fluttertoast.showToast(
            msg: "Email not found, please enter a valid email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return null;
        }
        return FirebaseAuth.instance.currentUser;
      });

      if (user != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        Fluttertoast.showToast(
          msg: "Verification email has been sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to send verification email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  bool isValidEmail(String email) {
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailRegex).hasMatch(email);

  }
}

