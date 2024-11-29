import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_lib/models/orders.dart';

class OrdersController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrderToFirestore(Orders order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set(order.toMap());
      notifyListeners();
    } catch (e) {
      log('Failed to add order: $e');
    }
  }

  Future<List<Orders>> fetchOrdersByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Orders> orders = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Orders.fromMap(data);
        }).toList();
        return orders;
      } else {
        log('No orders found for user with ID $userId');
        return [];
      }
    } catch (e) {
      log('Failed to fetch orders: $e');
      return [];
    }
  }

  Future<Orders?> fetchMostRecentOrderByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Orders> orders = querySnapshot.docs.map((doc) {
          return Orders.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        // Sort by timestamp in code if needed
        orders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return orders.first;
      } else {
        log('No orders found for user with ID $userId');
        return null;
      }
    } catch (e) {
      log('Failed to fetch most recent order: $e');
      return null;
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      // Update Firestore
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });

      notifyListeners();
      log('Order status updated successfully for order ID $orderId');
    } catch (e) {
      log('Failed to update order status for order ID $orderId: $e');
    }
  }
}
