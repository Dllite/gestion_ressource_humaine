import 'package:bloodd/widget/widget.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  const RoundedPasswordField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        obscureText: true,
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          hintText: "Mot de passe",
          hintStyle: const TextStyle(color: Colors.blue),
          suffixIcon: Icon(
            Icons.visibility,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
