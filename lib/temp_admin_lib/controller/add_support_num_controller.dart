import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSupportNumController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addSupportNumber(String supportNumber) async {
    setLoading(true);
    try {
      CollectionReference supportNumbers = _firestore.collection('supportNumbers');
      await supportNumbers.add({
        'number': supportNumber,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log("Failed to add support number: $e");
    } finally {
      setLoading(false);
    }
  }
}
