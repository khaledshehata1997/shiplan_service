import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';

class ProductController with ChangeNotifier {
  List<Product> products = [];
  List<Product> bestsellerProducts = [];
  int? selectedOptionIndex;

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      List<Product> fetchedProducts = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
        fetchedProducts.add(Product.fromMap(productData));
      }

      products = fetchedProducts;

      fetchedProducts.sort((a, b) => b.sold.compareTo(a.sold));
      bestsellerProducts = fetchedProducts.take(4).toList();

      notifyListeners();
    } catch (e) {
      log("Error fetching products: $e");
    }
  }

  void updateQuantityInCart(Product product, String action) {
    if (action == 'add') {
      product.quantityInCart++;
    } else if (action == 'sub') {
      product.quantityInCart--;
    }
    log('${product.quantityInCart}');
    notifyListeners();
  }
}
