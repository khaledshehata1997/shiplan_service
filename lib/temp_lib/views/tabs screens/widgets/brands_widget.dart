import 'dart:convert';

import 'package:flutter/material.dart';

class BrandsWidget extends StatelessWidget {
  const BrandsWidget(
      {super.key,
      required this.name,
      required this.image,
      required this.isviewAll});
  final String name;
  final String image;
  final bool isviewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: isviewAll ? 157 : 90,
          width: isviewAll ? 157 : 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.shade50,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.memory(
              base64Decode(image),
              height: isviewAll ? 157 : 90,
              width: isviewAll ? 157 : 90,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(name)
      ],
    );
  }
}
