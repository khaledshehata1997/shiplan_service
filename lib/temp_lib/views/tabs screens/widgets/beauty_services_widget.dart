import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';

class BeautyServicesWidget extends StatelessWidget {
  const BeautyServicesWidget(
      {super.key, required this.name, required this.image});
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 55,
          height: 70,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: defaultColor),
              image: DecorationImage(
                  image: MemoryImage(base64Decode(image)), fit: BoxFit.fill)),
        ),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        )
      ],
    );
  }
}
