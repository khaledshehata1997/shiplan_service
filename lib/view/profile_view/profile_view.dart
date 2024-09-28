import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:shiplan_service/view/auth_view/sign_in_view.dart';
import 'package:shiplan_service/view/profile_view/settings.dart';
import 'package:shiplan_service/view/view_model/user_model.dart';

import '../../constants.dart';
import 'change_password.dart';

class Profile extends StatefulWidget {
  UserModel userModel;
  Profile({super.key, required this.userModel});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to delete user account
  Future<void> _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        Get.snackbar(
          "تم حذف الحساب",
          "تم حذف حسابك بنجاح.",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(SignIn()); 
      } else {
        Get.snackbar(
          "فشل في حذف الحساب",
          "لا يوجد مستخدم مسجل حالياً.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "فشل في حذف الحساب",
        "حدث خطأ أثناء محاولة حذف الحساب: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Method to log out the user
  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Get.snackbar(
        "تم تسجيل الخروج",
        "تم تسجيل خروجك بنجاح.",
        snackPosition: SnackPosition.BOTTOM,
      );
     Get.offAll(SignIn()); 
    } catch (e) {
      Get.snackbar(
        "فشل تسجيل الخروج",
        "حدث خطأ أثناء محاولة تسجيل الخروج: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("الملف الشخصي", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const Settings());
            },
            icon: Icon(Icons.settings, color: Colors.black),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.18),
              Text(
                textDirection: TextDirection.rtl,
                'الأسم كامل',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),
              SizedBox(height: Get.height * 0.01),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    labelText: '${widget.userModel.name}',
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Text(
                textDirection: TextDirection.rtl,
                'البريد الألكتروني',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),
              SizedBox(height: Get.height * 0.01),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    labelText: '${widget.userModel.email}',
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Text(
                textDirection: TextDirection.rtl,
                'كلمه السر',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),
              SizedBox(height: Get.height * 0.01),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                      labelText: '***********',
                      suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(const ChangePass());
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    child: Text(
                      "تغيير كلمه المرور",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: _logout, // Call logout method
                    style:
                        ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    child: Text(
                      "تسجيل الخروج",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: Get.height * 0.06,
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDeleteAccountConfirmation(); // Call confirmation dialog
                    },
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: buttonColor, width: 2),
                        backgroundColor: Colors.white),
                    child: Text(
                      "ازاله الحساب",
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show confirmation dialog
  void _showDeleteAccountConfirmation() {
    Get.defaultDialog(
      title: "حذف الحساب",
      middleText: "هل أنت متأكد من أنك تريد حذف الحساب؟",
      textConfirm: "نعم",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      onConfirm: () {
        _deleteAccount();
        Get.back();
      },
      onCancel: () {},
    );
  }
}
