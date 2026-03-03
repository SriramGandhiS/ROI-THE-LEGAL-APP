import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/screens/google_welcome_screen.dart';
import 'package:login_signup/screens/signin_screen.dart';
import 'package:login_signup/screens/verify.dart';
import 'package:login_signup/screens/language.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.emailVerified) {
              return LanguageSelectionScreen();
            } else {
              return const Verify();
            }
          } else {
            return const SignInScreen();
          }
        });
  }
}

