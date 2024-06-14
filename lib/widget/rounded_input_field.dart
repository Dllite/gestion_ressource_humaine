import 'package:bloodd/widget/widget.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField(
      {super.key,
      this.hinText,
      this.icon = Icons.person,
      required this.controller});

  final String? hinText;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
          hintText: hinText,
          hintStyle: const TextStyle(color: Colors.blue),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
