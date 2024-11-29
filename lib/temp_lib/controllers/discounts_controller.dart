import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscountsController with ChangeNotifier {
  Future<List<Map<String, dynamic>>> fetchDiscounts() async {
  List<Map<String, dynamic>> discounts = [];
  
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('discounts').get();
    
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> discountsData = doc.data() as Map<String, dynamic>;
      discountsData['id'] = doc.id;
      discounts.add(discountsData);
    }
  } catch (e) {
    log("Error fetching discounts: $e");
  }
    notifyListeners();
  return discounts;
}
}