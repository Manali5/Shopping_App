import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextInputAction textInputAction;
  final bool isPassword;

  CustomInput({required this.hintText, required this.onChanged, required this.textInputAction, required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: BoxDecoration(
        color: Color(0xFFFFE0DEDE),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: TextField(
        obscureText: isPassword,
        onChanged: onChanged,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        ),
        style: TextStyle(fontSize: 14),
      )
    );
  }
}
