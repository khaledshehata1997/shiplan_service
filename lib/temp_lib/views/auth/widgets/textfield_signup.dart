import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextfieldSignup extends StatelessWidget {
  const TextfieldSignup(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.icon,
      required this.type,
      required this.inputFormatters,
      this.suffixIcon,
      this.obscureText,
      this.image});
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final IconButton? suffixIcon;
  final bool? obscureText;
  final String? image;
  final TextInputType type;
  final List<TextInputFormatter> inputFormatters;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        color: Colors.black,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please fill this field';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        controller.text = newValue!;
      },
      cursorColor: Colors.black,
      obscuringCharacter: '*',
      obscureText: obscureText ?? false,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: image == null
            ? Icon(icon, color: Colors.grey)
            : Image.asset(image!),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
