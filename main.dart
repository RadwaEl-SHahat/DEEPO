
import 'package:flutter/material.dart';
import 'MySplashPage.dart';
import 'package:firebase_core/firebase_core.dart';



bool isFirebaseConnected = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyDCyhHmUrCauYOzU9A-4BjrLkIbARmoQKY",
        appId: "1:698570304969:android:2093c6b2fb07ee8c18",
        messagingSenderId: '698570304969',
        projectId: "deepo-f9fa2")
  );
  runApp(MyApp());
}
Future<void> initializeFirebase() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    // If initialization is successful, update the connection status
    isFirebaseConnected = true;
  } catch (e) {
    // If initialization fails, keep the connection status as false
    isFirebaseConnected = false;
    print('Failed to connect to Firebase: $e');
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DEEPO',
      home: SplashScreen(),
    );
  }
}

