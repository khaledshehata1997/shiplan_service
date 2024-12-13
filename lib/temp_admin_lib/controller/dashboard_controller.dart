import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardController with ChangeNotifier {
  int productSold = 0;
  int productRefunded = 0;

  Future<int> getTotalUsers() async {
    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("tempUsers").get();
    return userSnapshot.docs.length;
  }

  Future<int> getTotalBuyers() async {
    try {
      QuerySnapshot buyerSnapshot = await FirebaseFirestore.instance
          .collection("tempUsers")
          .where('buyer', isEqualTo: true)
          .get();

      return buyerSnapshot.docs.length;
    } catch (e) {
      log('Error fetching buyers: $e');
      return 0;
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<num> getTotalSalesRevenue() async {
    num totalSalesRevenue = 0;

    try {
      // Fetch all products from Firestore
      QuerySnapshot snapshot = await firestore.collection('products').get();

      // Iterate through each product document
      for (var product in snapshot.docs) {
        var data = product.data() as Map<String, dynamic>;

        // Check if both 'sold' and 'price' fields exist
        if (data.containsKey('sold') &&
            data.containsKey('price') &&
            data['sold'] is num &&
            data['price'] is num) {
          // Multiply sold quantity by price to get sales revenue for each product
          totalSalesRevenue += data['sold'] * data['price'];
        }
      }
    } catch (e) {
      log('Error fetching products: $e');
      return 0;
    }

    return totalSalesRevenue;
  }

  Future<void> getTotalBoughtProducts() async {
    num totalBoughtProducts = 0;

    try {
      QuerySnapshot snapshot = await firestore.collection('products').get();

      for (var product in snapshot.docs) {
        var data = product.data() as Map<String, dynamic>;

        if (data.containsKey('sold') && data['sold'] is num) {
          totalBoughtProducts += data['sold'];
        }
      }
      productSold = totalBoughtProducts.toInt();
      notifyListeners();
    } catch (e) {
      log('Error fetching products: $e');
    }
  }

  Future<void> getTotalRefundedProducts() async {
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');
    int totalRefundedProducts = 0;

    try {
      QuerySnapshot refundedOrdersSnapshot =
          await ordersCollection.where('status', isEqualTo: 'Refunded').get();

      if (refundedOrdersSnapshot.docs.isEmpty) {
        log("No refunded products found.");
        return;
      }
      for (var doc in refundedOrdersSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
        List<String> productIds = List<String>.from(data['ids'] ?? []);
        totalRefundedProducts += productIds.length;
      }

      log("Total refunded products: $totalRefundedProducts");
      productRefunded = totalRefundedProducts;
      notifyListeners();
    } catch (e) {
      log("Error retrieving total refunded products: $e");
    }
  }
}
