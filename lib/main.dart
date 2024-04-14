// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:money_counter/moeny_counter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Counter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MoneyCounter(title: 'Money Counter'),
    );
  }
}
