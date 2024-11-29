import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryController with ChangeNotifier {
  Future<List<Map<String, dynamic>>> fetchCategories() async {
  List<Map<String, dynamic>> categories = [];
  
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> categoryData = doc.data() as Map<String, dynamic>;
      categories.add(categoryData);
    }
  } catch (e) {
    log("Error fetching categories: $e");
  }

  return categories;
}
}