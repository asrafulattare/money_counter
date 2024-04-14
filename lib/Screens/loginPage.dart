import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import '../helper/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onTap});
  final Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgotPasswordController = TextEditingController();

  // forgot email

  void forgotPassword() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try forgot email send
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgotPasswordController.text);
      forgotPasswordController.clear();
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset Password link will be send..'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }
    }
  }

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
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
                const SizedBox(height: 35),

                // logo
                const Text(
                  '৳',
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 35),

                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),
                SizedBox(
                  width: context.isMobile
                      ? double.infinity
                      : 450, //Make it responsive for web
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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

                      // forgot password?
                      GestureDetector(
                        onTap: () => forgotDialog(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // sign in button
                      MyButton(
                        text: 'Sing In',
                        onTap: signUserIn,
                      ),

                      const SizedBox(height: 50),

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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                        onTap: () => kIsWeb
                            ? signInWithGoogleWeb(context)
                            : AuthService().singInWithGoolge(),
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

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
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

  Future<dynamic> forgotDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GiffyDialog(
          backgroundColor: Colors.grey[300],
          giffy: Column(children: [
            const SizedBox(height: 8),
            const Text(
              'Account recovery password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'To get a verification link, enter your email address',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // email textfield
            MyTextField(
              keyboardType: TextInputType.emailAddress,
              controller: forgotPasswordController,
              hintText: 'Email',
              obscureText: false,
            ),
          ]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'CANCEL'),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () => forgotPassword(),
              child: const Text('SEND',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        );
      },
    );
  }
}
