import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShippingChargeController with ChangeNotifier {
  double _shippingCharge = 0.0;
  double get shippingCharge => _shippingCharge;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> fetchShippingCharge() async {
  try {
    DocumentSnapshot doc = await _firestore.collection('settings').doc('shipping').get();
    if (doc.exists) {
      _shippingCharge = (doc['charge'] as num).toDouble();
      notifyListeners();
    }
  } catch (error) {
    log('Error fetching shipping charge: $error');
  }
}
}