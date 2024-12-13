import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBrandController with ChangeNotifier {
  Future<void> addBrand(String name, String imageUrl, String nameAr) async {
    CollectionReference brands =
        FirebaseFirestore.instance.collection('brands');
    DocumentReference docRef = brands.doc();

    await docRef.set({
      'id': docRef.id,
      'name': name,
      'nameAr': nameAr,
      'image': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) {
      log("Brand added with ID: ${docRef.id}");
      fetchBrands();
      notifyListeners();
    }).catchError((error) {
      log("Error adding Brand: $error");
    });
  }

  Future<List<Map<String, dynamic>>> fetchBrands() async {
    List<Map<String, dynamic>> brands = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('brands').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> brandData = doc.data() as Map<String, dynamic>;
        brands.add(brandData);
      }
    } catch (e) {
      log("Error fetching brands: $e");
    }

    return brands;
  }

  Future<void> deleteBrand(String brandId) async {
    CollectionReference brands =
        FirebaseFirestore.instance.collection('brands');

    await brands.doc(brandId).delete().then((_) {
      log("Brand with ID $brandId deleted");
      fetchBrands();
      notifyListeners(); // Notify listeners to update the UI after deletion
    }).catchError((error) {
      log("Error deleting brand: $error");
    });
  }

  Future<void> updateBrand(
      {required String brandId,
      required Map<String, dynamic> updatedData}) async {
    DocumentReference brandRef =
        FirebaseFirestore.instance.collection('brands').doc(brandId);

    updatedData['updatedAt'] = FieldValue.serverTimestamp();

    if (updatedData.isNotEmpty) {
      await brandRef.update(updatedData).then((_) {
        log('Brand updated with id: $brandId');
        fetchBrands();
        notifyListeners();
      }).catchError((error) {
        log("Error updating brand: $error");
      });
    }
  }
}
