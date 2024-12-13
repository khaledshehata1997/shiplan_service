import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategoryController with ChangeNotifier {
  Future<void> addCategory(
      String nameEn, String nameAr, String imageUrl) async {
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');

    DocumentReference docRef = categories.doc();

    await docRef.set({
      'id': docRef.id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'image': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) {
      log('Category added with id: ${docRef.id}');
      fetchCategories();
    }).catchError((error) {
      log("Error adding category: $error");
    });
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    List<Map<String, dynamic>> categories = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> categoryData = doc.data() as Map<String, dynamic>;
        categories.add(categoryData);
      }
    } catch (e) {
      log("Error fetching categories: $e");
    }

    return categories;
  }

  Future<void> editCategory(String id, Map<String, dynamic> updatedData) async {
    DocumentReference categoryRef =
        FirebaseFirestore.instance.collection('categories').doc(id);

    updatedData['updatedAt'] = FieldValue.serverTimestamp();

    if (updatedData.isNotEmpty) {
      await categoryRef.update(updatedData).then((_) {
        log('Category updated with id: $id');
        fetchCategories();
        notifyListeners();
      }).catchError((error) {
        log("Error updating category: $error");
      });
    }
  }

  Future<void> deleteCategory(String id) async {
    DocumentReference categoryRef =
        FirebaseFirestore.instance.collection('categories').doc(id);

    await categoryRef.delete().then((_) {
      log('Category deleted with id: $id');
      fetchCategories();
      notifyListeners();
    }).catchError((error) {
      log("Error deleting category: $error");
    });
  }
}
