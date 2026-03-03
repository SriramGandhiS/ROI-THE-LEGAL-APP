import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:get/route_manager.dart';
import 'package:login_signup/screens/wrapper.dart';
import 'package:login_signup/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBNtH5NGKJc1LCul7xYq_1mPOlu4gugN64",
        authDomain: "myappconsi.firebaseapp.com",
        databaseURL: "https://myappconsi-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "myappconsi",
        storageBucket: "myappconsi.firebasestorage.app",
        messagingSenderId: "224150240249",
        appId: "1:224150240249:web:6d56af8ed528bd38ec1b28",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  
  // Initialize flutter_gemini before app starts
  Gemini.init(apiKey: 'AIzaSyDc2NUcfiSlJdCYH7cNoOJN0hWcr7enGqQ');

  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ROI',
      theme: lightMode,
      home: const Wrapper(),
    );
  }
}
