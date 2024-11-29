import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CouponController with ChangeNotifier {
  Future<List<Map<String, dynamic>>> fetchCoupons() async {
    List<Map<String, dynamic>> coupons = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('coupons').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> couponsData = doc.data() as Map<String, dynamic>;
        coupons.add(couponsData);
      }
    } catch (e) {
      log("Error fetching coupons: $e");
    }

    return coupons;
  }
}