import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.keyboardType,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kIsWeb ? 500 : double.infinity, //Make it responsive for web
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[500])),
        ),
      ),
    );
  }
}
