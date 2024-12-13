import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductController with ChangeNotifier {
  Future<void> addProduct({
    required String name,
    required String imageUrl,
    required double price,
    required int stock,
    required String description,
    required String categoryId,
    required String brandId,
    required String nameAr,
    required String arDescription,
    required List<String> optionsImages,
    required List<int> colors,
    required List<int> colorsQuantity,
  }) async {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    DocumentReference docRef = products.doc();

    await docRef.set({
      'id': docRef.id,
      'name': name,
      'nameAr': nameAr,
      'price': price,
      'image': imageUrl,
      'description': description,
      'arDescription': arDescription,
      'stock': stock,
      'categoryId': categoryId,
      'brandId': brandId,
      'sold': 0,
      'colors': colors,
      'colorsQuantity': colorsQuantity,
      'optionImages': optionsImages,
      'quantityInCart': 1,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) {
      log("Product added with ID: ${docRef.id}");
      fetchProducts();
      notifyListeners();
    }).catchError((error) {
      log("Error adding Product: $error");
    });
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    List<Map<String, dynamic>> products = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
        productData['id'] = doc.id;
        products.add(productData);
      }
    } catch (e) {
      log("Error fetching products: $e");
    }

    return products;
  }

  Future<void> deleteProduct(String productId) async {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    await products.doc(productId).delete().then((_) {
      log("Product with ID $productId deleted");
      fetchProducts();
      notifyListeners();
    }).catchError((error) {
      log("Error deleting product: $error");
    });
  }

  Future<void> updateProduct({
    required String productId,
    String? nameAr,
    String? name,
    String? imageUrl,
    double? price,
    int? stock,
    String? description,
    String? categoryId,
    String? brandId,
    String? arDescription,
    List<String>? optionsImages,
    List<int>? colors,
    List<int>? colorsQuantity,
  }) async {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    Map<String, dynamic> updatedData = {};
    if (name != null) updatedData['name'] = name;
    if (nameAr != null) updatedData['nameAr'] = nameAr;
    if (imageUrl != null) updatedData['image'] = imageUrl;
    if (price != null) updatedData['price'] = price;
    if (stock != null) updatedData['stock'] = stock;
    if (description != null) updatedData['description'] = description;
    if (description != null) updatedData['arDescription'] = arDescription;
    if (categoryId != null) updatedData['categoryId'] = categoryId;
    if (brandId != null) updatedData['brandId'] = brandId;
    if (colorsQuantity != null) updatedData['colorsQuantity'] = colorsQuantity;
    if (colors != null) updatedData['colors'] = colors;
    if (optionsImages != null) updatedData['optionImages'] = optionsImages;

    if (updatedData.isNotEmpty) {
      await products.doc(productId).update(updatedData).then((_) {
        log("Product with ID $productId updated");
        fetchProducts();
        notifyListeners();
      }).catchError((error) {
        log("Error updating product: $error");
      });
    }
  }
}
