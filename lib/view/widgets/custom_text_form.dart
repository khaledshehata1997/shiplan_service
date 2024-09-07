// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  bool? secure = false;
  String? hint;
  bool obsecure = false;
  TextEditingController? controller;
  void Function(String?)? onSave;
  String? Function(String?)? validate;
  final InputDecoration? decoration;
  CustomTextForm(
      {this.hint,
        this.secure,
        this.validate,
        this.onSave,
        this.controller,
        this.decoration,
        required this.obsecure});

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onSaved: widget.onSave,
      validator: widget.validate,
      obscureText: widget.obsecure,
      decoration: widget.decoration ??
          InputDecoration(
            hintStyle: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
            hintText: '${widget.hint}',
            suffixIcon: widget.secure == true
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.obsecure = !widget.obsecure;
                  });
                },
                child: const Icon(Icons.remove_red_eye))
                : null,
          ),
    );
  }
}
