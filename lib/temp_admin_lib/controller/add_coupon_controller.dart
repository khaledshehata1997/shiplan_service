// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class AddCouponController with ChangeNotifier {
  List<Map<String, dynamic>> _coupons = [];

  List<Map<String, dynamic>> get coupons => _coupons;

  bool isNameAdded = false;

  Future<void> addCoupon(
    BuildContext context, {
    required String nameEn,
    required int duration,
    required double sale,
    required int numberOfUse,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    CollectionReference coupons = FirebaseFirestore.instance.collection('coupons');

    QuerySnapshot querySnapshot = await coupons.where('name', isEqualTo: nameEn).get();

    if (querySnapshot.docs.isNotEmpty) {
      showTopSnackBar(
        context,
        "name already done before",
        Icons.check_circle,
        defaultColor,
        const Duration(seconds: 4),
      );
      isNameAdded = true;
      notifyListeners();
      return;
    }

    DocumentReference docRef = coupons.doc();

    await docRef.set({
      'id': docRef.id,
      'name': nameEn,
      'numberOfUse': numberOfUse,
      'duration': duration,
      'sale': sale,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) {
      log('Coupon added with id: ${docRef.id}');
      fetchAllCoupons();
      notifyListeners();
    }).catchError((error) {
      log("Error adding coupon: $error");
    });
  }

  Future<void> fetchAllCoupons() async {
    CollectionReference couponsCollection = FirebaseFirestore.instance.collection('coupons');

    try {
      QuerySnapshot querySnapshot = await couponsCollection.get();
      _coupons.clear();

      _coupons = querySnapshot.docs.map((doc) {
        return {
          'id': doc['id'],
          'name': doc['name'],
          'numberOfUse': doc['numberOfUse'],
          'duration': doc['duration'],
          'sale': doc['sale'],
          'createdAt': doc['createdAt'],
          'startDate': doc['startDate'],
          'endDate': doc['endDate']
        };
      }).toList();
      fetchAllCoupons();
      notifyListeners();
    } catch (error) {
      log("Error fetching coupons: $error");
    }
  }

  Future<void> editCoupon(
    BuildContext context, {
    required String couponId,
    required String nameEn,
    required int duration,
    required double sale,
    required int numberOfUse,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    CollectionReference coupons = FirebaseFirestore.instance.collection('coupons');

    try {
      // Update the existing coupon document
      await coupons.doc(couponId).update({
        'name': nameEn,
        'numberOfUse': numberOfUse,
        'duration': duration,
        'sale': sale,
        'startDate': Timestamp.fromDate(startDate), // Convert to Firestore Timestamp
        'endDate': Timestamp.fromDate(endDate),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      showTopSnackBar(
        context,
        "coupon updated successfully",
        Icons.check_circle,
        defaultColor,
        const Duration(seconds: 4),
      );
      fetchAllCoupons();
      notifyListeners();
    } catch (error) {
      log("Error updating coupon: $error");
      showTopSnackBar(
        context,
        "error updating coupon",
        Icons.check_circle,
        defaultColor,
        const Duration(seconds: 4),
      );
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    CollectionReference coupons = FirebaseFirestore.instance.collection('coupons');

    try {
      // Delete the coupon document
      await coupons.doc(couponId).delete();

      // Remove the coupon from the local list
      _coupons.removeWhere((coupon) => coupon['id'] == couponId);
      log('Coupon with id: $couponId has been deleted.');
      fetchAllCoupons();
      // Notify listeners after deletion
      notifyListeners();
    } catch (error) {
      log('Error deleting coupon: $error');
    }
  }
}
