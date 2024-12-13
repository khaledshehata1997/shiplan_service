import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBeautyService with ChangeNotifier {
  Future<void> addBeautyService(String name, String imageUrl) async {
  CollectionReference beautyServices = FirebaseFirestore.instance.collection('beautyServices');

  try {
    DocumentReference docRef = beautyServices.doc();  
    await docRef.set({
      'name': name,
      'image': imageUrl,
      'id': docRef.id, 
      'createdAt': FieldValue.serverTimestamp(),
    });
    log("Beauty service added with ID: ${docRef.id}");
  } catch (error) {
    log("Error adding beauty service: $error");
  }
}


Future<List<Map<String, dynamic>>> fetchBeautyServices() async {
  List<Map<String, dynamic>> beautyServices = [];
  
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('beautyServices').get();
    
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> beautyServicesData = doc.data() as Map<String, dynamic>;
      beautyServicesData['id'] = doc.id;
      beautyServices.add(beautyServicesData);
    }
  } catch (e) {
    log("Error fetching beautyServices: $e");
  }

  return beautyServices;
}
}