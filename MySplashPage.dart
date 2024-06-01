// import 'package:flutter/material.dart';
// import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
//
// class MySplashPage extends StatefulWidget {
//   @override
//   _MySplashPageState createState() => _MySplashPageState();
// }
//
// class _MySplashPageState extends State<MySplashPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//       seconds: 12, // lowercase 's'
//       imageBackground: Image.asset('assets/logo.png').image,
//       useLoader: true, // lowercase 'u'
//       loaderColor: Colors.indigo, // lowercase 'l'
//       loadingText: Text('loading.....', style: TextStyle(color: Colors.pink)), // lowercase 'l'
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromRGBO(200, 200, 200, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png"),
            SizedBox(height: 20), // Add spacing between image and text
            Text(
              'loading.....',
              style: TextStyle(color: Colors.indigoAccent),
            ),
          ],
        ),
      ),
    );
  }
}
