import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.isAdmin,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '', // Check if `uid` exists in Firestore
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      isAdmin: data['isAdmin'] ?? false, // Check if `isAdmin` exists in Firestore
    );
  }
}

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserData(String uid) async {
     DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (snapshot.exists) {
    // Log the document data to confirm the fields are present
    print("User Data: ${snapshot.data()}");
    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  } else {
    throw Exception('User not found');
  }
  }
}
