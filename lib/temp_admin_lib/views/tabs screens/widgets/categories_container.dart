import 'dart:convert';

import 'package:flutter/material.dart';

class CategoriesContainer extends StatelessWidget {
  const CategoriesContainer({super.key,this.name, required this.image});
  final String? name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
            image: MemoryImage(base64Decode(image)), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 130,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            name != null? Text(
              name!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
