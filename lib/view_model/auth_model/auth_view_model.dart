import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiplan_service/view/home_view/nav_bar_view.dart';

import '../../constants.dart';
import '../../view/home_view/home_view.dart';
import 'auth_service.dart';

class AuthViewModel extends GetxController {
  bool isLoading = false;
  bool isPhotoLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
   String? email, password,password2;
   String? name;
  UserProfile? userProfile;
  Future<void> getUserProfile() async {
    userProfile = await _authService
        .getUserProfile(FirebaseAuth.instance.currentUser!.uid);
    if (userProfile!.isAdmin == true) {}
    update();
  }

// check if user is admin
  // Future<bool> checkIfAdmin() async {
  //   userProfile = await _authService
  //       .getUserProfile(FirebaseAuth.instance.currentUser!.uid);
  //   if (userProfile!.isAdmin == true) {}
  //   update();
  // }

  Future<void> uploadUserPhoto(String _imageFile) async {
    try {
      print('uploading');
      isPhotoLoading = true;
      update();
      await _authService.addPhoto(
          _imageFile, FirebaseAuth.instance.currentUser!.uid);
      print('uploaded');
      userProfile = await _authService
          .getUserProfile(FirebaseAuth.instance.currentUser!.uid);
      isPhotoLoading = false;
      update();
    } catch (e) {
      isPhotoLoading = false;
      update();
      Get.snackbar('Error', e.toString(),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
  }

  signUp() async {
    try {
      Get.snackbar(
        'Loading',
        'please wait',
        duration: const Duration(seconds: 2),
        backgroundColor: mainColor,
        snackPosition: SnackPosition.BOTTOM,
      );

      var data = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      _authService.createUserProfile(
        userId: data.user!.uid,
        name: name!,
        email: email!,
      );

      userProfile = await _authService.getUserProfile(data.user!.uid);
      if (userProfile!.isAdmin == true) {
        // isAdmin = true;
      }
      Get.offAll(const NavBarView());
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString(),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
    update();
  }

  updateProfile({
    String? name,
    String? phone,
    String? cr,
    String? vat,
  }) async {
    try {
      Get.snackbar(
        'Loading',
        'please wait',
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
      await _authService.updateUserProfile(
        userId: FirebaseAuth.instance.currentUser!.uid,
        name: name!,
        email: email!,
      );

      userProfile = await _authService
          .getUserProfile(FirebaseAuth.instance.currentUser!.uid);

      Get.to(const NavBarView());
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
      }
      if (kDebugMode) {
        print(s);
      }
      Get.snackbar('Error', e.toString(),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
    update();
  }

  signIn() async {
    try {
      Get.snackbar('Loading', 'please wait',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: mainColor);
      var data = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      userProfile = await _authService.getUserProfile(data.user!.uid);
      if (userProfile!.isAdmin == true || userProfile!.role == 'admin') {
        // isAdmin = true;
      }
      AdminProvider().checkIfAdmin();
      isLoading = false;
      Get.offAll(const NavBarView());
    } catch (e) {
      isLoading = true;
      Get.snackbar('Error', e.toString(),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
      isLoading = false;
    }
    update();
  }
}
