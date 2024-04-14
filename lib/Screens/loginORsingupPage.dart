import 'package:flutter/material.dart';
import 'package:money_counter/Screens/loginPage.dart';
import 'package:money_counter/Screens/signupPage.dart';

class LoginOrSingup extends StatefulWidget {
  const LoginOrSingup({super.key});

  @override
  State<LoginOrSingup> createState() => _LoginOrSingupState();
}

class _LoginOrSingupState extends State<LoginOrSingup> {
  // show intial login page
  bool showLoginPage = true;

  // toggle between login and singup pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return SingUp(
        onTap: togglePages,
      );
    }
  }
}
