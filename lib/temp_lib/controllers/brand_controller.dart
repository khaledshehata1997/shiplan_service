import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BrandController with ChangeNotifier {
  Future<List<Map<String, dynamic>>> fetchBrands() async {
    List<Map<String, dynamic>> brands = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('brands').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> brandsData = doc.data() as Map<String, dynamic>;
        brandsData['id'] = doc.id;
        brands.add(brandsData);
      }
    } catch (e) {
      log("Error fetching brands: $e");
    }

    return brands;
  }
}
