import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final String id;
  final List<String> productName;
  final List<String> productIds;
  final List<String> image;
  final List<int> qty;
  final List<double> productPrice;
  final double totalPrice;
  final String status;
  final String userId;
  final String address;
  final String phoneNumber;
  final int? selectedOptionIndex;
  final String paymentType;
  final Timestamp timestamp; // New field for timestamp

  Orders({
    required this.id,
    required this.productName,
    required this.productIds,
    required this.image,
    required this.qty,
    required this.productPrice,
    required this.totalPrice,
    required this.status,
    required this.userId,
    required this.address,
    required this.phoneNumber,
    this.selectedOptionIndex,
    required this.paymentType,
    required this.timestamp, // Initialize timestamp
  });

  static String generateRandomId() {
    final random = Random();
    return random.nextInt(1000000).toString();
  }

  factory Orders.fromMap(Map<String, dynamic> map) => Orders(
        id: map['id'],
        productName: List<String>.from(map['productName']),
        productIds: List<String>.from(map['ids']),
        image: List<String>.from(map['image']),
        qty: List<int>.from(map['qty']),
        productPrice: List<double>.from(map['productPrice']),
        totalPrice: map['totalPrice'],
        status: map['status'],
        userId: map['userId'],
        address: map['address'],
        phoneNumber: map['phoneNumber'],
        selectedOptionIndex: map['selectedOptionIndex'],
        paymentType: map['paymentType'],
        timestamp: map['timestamp'] ?? Timestamp.now(), // Handle timestamp
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'ids': productIds,
      'image': image,
      'qty': qty,
      'productPrice': productPrice,
      'totalPrice': totalPrice,
      'status': status,
      'userId': userId,
      'address': address,
      'phoneNumber': phoneNumber,
      'selectedOptionIndex': selectedOptionIndex,
      'paymentType': paymentType,
      'timestamp': timestamp, // Include timestamp in map
    };
  }
}
