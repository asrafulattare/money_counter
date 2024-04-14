import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import '../helper/firebase_auth.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key, required this.onTap});
  final Function()? onTap;

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Get the current user
    User? user = _auth.currentUser;

    // try creating the user
    try {
      // check if password is confirm
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        //

        if (user != null) {
          // Create the "moneycount" collection with the UID as document ID
          await _firestore.collection('moneycount').doc(user.uid).set({
            'data': 'Your data goes here', // Add your data here
          });

          print('Moneycount collection created with document ID: ${user.uid}');
        } else {
          print('User is not logged in');
        }
      } else {
        // show error password dosen't match
        notMatchPasswordMessage();
      }

      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // password dosen't match  message popup
  void notMatchPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'password didn\'t match',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // logo
                const Text(
                  '৳',
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 35),

                // welcome back, you've been missed!
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 8),

                // password textfield
                MyTextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 8),

                // confirm password textfield
                MyTextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  text: "Sing Up",
                  onTap: signUserUp,
                ),

                const SizedBox(height: 35),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ).w(
                  kIsWeb ? 450 : double.infinity,
                ), //Make it responsive for web),

                const SizedBox(height: 35),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                        onTap: () => AuthService().singInWithGoolge(),
                        imagePath:
                            'https://raw.githubusercontent.com/mitchkoko/ModernLoginUI/main/lib/images/google.png'),

                    const SizedBox(width: 25),

                    // apple button

                    // Platform.isIOS
                    //     ? SquareTile(
                    //         onTap: () {},
                    //         imagePath:
                    //             'https://raw.githubusercontent.com/mitchkoko/ModernLoginUI/main/lib/images/apple.png')
                    //     : VxBox().make()
                  ],
                ),

                const SizedBox(height: 35),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
