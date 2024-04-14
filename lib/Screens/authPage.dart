import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';
import 'loginORsingupPage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              return const HomePage();
            }

            // user is NOT logged in
            else {
              return const LoginOrSingup();
            }
          },
        ),
      ),
    );
  }
}
