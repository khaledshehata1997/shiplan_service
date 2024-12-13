import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdvertismentsController with ChangeNotifier {
  Future<void> addAdvertisment(String base64Image) async {
    CollectionReference advertisments =
        FirebaseFirestore.instance.collection('discounts');
    DocumentReference docRef = advertisments.doc();

    await docRef.set({
      'id': docRef.id,
      'image': base64Image,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) {
      log('Advertisment added with ID: ${docRef.id}');
      fetchAdvertisment();
      notifyListeners();
    }).catchError((error) {
      log("Error adding advertisment: $error");
    });
  }

  Future<List<Map<String, dynamic>>> fetchAdvertisment() async {
    List<Map<String, dynamic>> advertisments = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('discounts').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> advertismentData =
            doc.data() as Map<String, dynamic>;
        advertismentData['id'] = doc.id; // Add the document ID
        advertisments.add(advertismentData);
      }
    } catch (e) {
      log("Error fetching advertisments: $e");
    }

    return advertisments;
  }

  Future<void> deleteAdvertisment(String advertismentId) async {
    CollectionReference advertisments =
        FirebaseFirestore.instance.collection('discounts');

    await advertisments.doc(advertismentId).delete().then((_) {
      log("Advertisment with ID $advertismentId deleted");
      fetchAdvertisment();
      notifyListeners();
    }).catchError((error) {
      log("Error deleting advertisment: $error");
    });
  }

  Future<void> updateAdvertisment({
    required String advertismentId,
    String? name,
    String? nameAr,
    String? imageUrl,
    double? discountValue,
  }) async {
    CollectionReference advertisments =
        FirebaseFirestore.instance.collection('discounts');

    Map<String, dynamic> updatedData = {};
    if (name != null) updatedData['name'] = name;
    if (imageUrl != null) updatedData['image'] = imageUrl;
    if (discountValue != null) updatedData['discountValue'] = discountValue;

    if (updatedData.isNotEmpty) {
      await advertisments.doc(advertismentId).update(updatedData).then((_) {
        log("Advertisment with ID $advertismentId updated");
        fetchAdvertisment();
        notifyListeners();
      }).catchError((error) {
        log("Error updating advertisment: $error");
      });
    }
  }
}
