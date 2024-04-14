import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:money_counter/routs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyALWON5PtFykuQpf08ZALhvZeOZLIXsJW0",
          authDomain: "moneycountbd.firebaseapp.com",
          projectId: "moneycountbd",
          storageBucket: "moneycountbd.appspot.com",
          messagingSenderId: "312732224236",
          appId: "1:312732224236:web:b51a2ed6d72174467d73c9",
          measurementId: "G-B13T7TQX2K"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Money Counter',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blueGrey,
      ),
      routerConfig: router,
    );
  }
}
