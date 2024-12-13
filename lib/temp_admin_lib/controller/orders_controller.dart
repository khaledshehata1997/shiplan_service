import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersControllerAdmin with ChangeNotifier {
  Future<List<Map<String, dynamic>>> fetchAllOrders() async {
    try {
      CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');
      QuerySnapshot orderSnapshot = await ordersCollection.get();

      // Convert each document to Map<String, dynamic> and cast lists properly
      List<Map<String, dynamic>> orders = orderSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Explicitly casting lists to the correct type
        data['productName'] = List<String>.from(data['productName']);
        data['image'] = List<String>.from(data['image']);
        data['qty'] = List<int>.from(data['qty']);
        data['productPrice'] = List<double>.from(data['productPrice']);

        return data;
      }).toList();

      return orders;
    } catch (error) {
      log("Error fetching orders: $error");
      return [];
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');

      // Update the status of the order
      await ordersCollection.doc(orderId).update({
        'status': newStatus,
      });
      notifyListeners();
      log('Order $orderId status updated to $newStatus');
    } catch (error) {
      log('Error updating order status: $error');
    }
  }

  Future<String?> fetchUserIdByOrderId(String orderId) async {
    try {
      CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');

      // Query for the document where 'id' matches the specified orderId
      QuerySnapshot orderSnapshot =
          await ordersCollection.where('id', isEqualTo: orderId).limit(1).get();

      // Check if any document is returned
      if (orderSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = orderSnapshot.docs.first.data() as Map<String, dynamic>;
        return data['userId'] as String; // Return the userId
      } else {
        log("No order found with orderId: $orderId");
        return null;
      }
    } catch (error) {
      log("Error fetching userId for orderId $orderId: $error");
      return null;
    }
  }

  Future<void> refundOrder(String userId, String orderId, BuildContext context) async {
    CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');
    CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');

    // Fetch the specific order by orderId and userId
    QuerySnapshot orderSnapshot = await ordersCollection
        .where('userId', isEqualTo: userId)
        .where('id', isEqualTo: orderId)
        .limit(1)
        .get();

    if (orderSnapshot.docs.isNotEmpty) {
      DocumentSnapshot orderDoc = orderSnapshot.docs.first;
      Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;

      List<String> productIds = List<String>.from(orderData['ids']);
      List<int> productQuantities = List<int>.from(orderData['qty']);
      int selectedColorIndex = orderData['selectedOptionIndex'];
      log('$selectedColorIndex');
      List<int> colorQuantities = [];

      for (int i = 0; i < productIds.length; i++) {
        String productId = productIds[i];
        int quantity = productQuantities[i];

        DocumentReference productDoc = productsCollection.doc(productId);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(productDoc);

          if (snapshot.exists) {
            int currentStock = snapshot['stock'];
            int currentSold = snapshot['sold'];
            colorQuantities = List<int>.from(snapshot['colorsQuantity']);

            // Increase stock and decrease sold quantities (undo the changes)
            transaction.update(productDoc, {
              'stock': currentStock + quantity,
              'sold': currentSold - quantity,
              'colorsQuantity': colorQuantities..[selectedColorIndex] += quantity,
              'refunded': FieldValue.increment(quantity),
            });

            log("Product updated after refund: $productId");
          } else {
            log("Product does not exist: $productId");
          }
        }).catchError((error) {
          log("Error updating product stock and sold for refund: $error");
        });
      }

      // Update the order status to "Refunded"
      await ordersCollection.doc(orderDoc.id).update({
        'status': 'Refunded',
      }).then((_) {
        log("Order status updated to 'Refunded' for order: $orderId");
      }).catchError((error) {
        log("Error updating order status: $error");
      });
    } else {
      log("Order not found for user: $userId");
    }
  }
}
