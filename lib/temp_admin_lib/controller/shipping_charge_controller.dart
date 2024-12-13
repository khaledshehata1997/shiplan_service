import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShippingChargeControllerAdmin with ChangeNotifier {
  double _shippingCharge = 0.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double get shippingCharge => _shippingCharge;

  // Function to add a new shipping charge
  Future<void> addShippingCharge(double charge) async {
    try {
      await _firestore.collection('settings').doc('shipping').set({
        'charge': charge,
      });
      _shippingCharge = charge;
      notifyListeners();
    } catch (error) {
      log('Error adding shipping charge: $error');
    }
  }

  // Function to edit the existing shipping charge
  Future<void> editShippingCharge(double charge) async {
    try {
      await _firestore.collection('settings').doc('shipping').update({
        'charge': charge,
      });
      _shippingCharge = charge;
      notifyListeners();
    } catch (error) {
      log('Error editing shipping charge: $error');
    }
  }

  Future<void> fetchShippingCharge() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('settings').doc('shipping').get();
      if (doc.exists) {
        _shippingCharge = doc['charge'];
        notifyListeners();
      }
    } catch (error) {
      log('Error fetching shipping charge: $error');
    }
  }
}
