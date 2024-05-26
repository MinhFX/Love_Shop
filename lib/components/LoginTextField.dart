import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {

  final controller;
  final TextInputType textInputType;
  final Icon icons;
  final String hintText;
  final String labelText;
  final bool obscureText;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.textInputType,
    required this.icons,
    required this.labelText,
    required this.hintText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Material(
        elevation: 12,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(10),
        child: TextField(
          cursorColor: Colors.black,
          cursorErrorColor: Colors.redAccent,
          controller: controller,
          obscureText: obscureText,
          keyboardType: textInputType,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.black
            ),
            helperStyle: const TextStyle(
              color: Colors.black
            ),
            labelText: labelText,
            hintText: hintText,
            prefixIcon: icons,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }
}

