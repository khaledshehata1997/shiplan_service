import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shiplan_service/view/profile_view/settings.dart';

import '../../constants.dart';
import 'change_password.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions:  [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: IconButton(onPressed:(){
              Get.to(const Settings());
            },icon:Icon(Icons.settings,color: Colors.black),
            ),
          )
        ],
      ),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.height * 0.8,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 6.0,
                    ),
                  ],
                  color: Colors.white, // Set the background color of the container
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 150,// Adjust this value to position the circle correctly
              // left: 0,
              // right: 0,
              child: Stack(
                children: [
                  // Circular image
                  ClipOval(
                    child: Container(
                      color: Colors.white, // Optional: Background color behind the image
                      width: 80, // Diameter of the circle
                      height: 80, // Diameter of the circle
                      child: Image.network(
                        "https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/421043326_1051227129677442_2723558836913506429_n.jpg?ccb=11-4&oh=01_Q5AaINlcPoXi-vGTZnw-dO7JrhqSkw9eonUE1c6nxW4gf1I2&oe=66E6D5A2&_nc_sid=5e03e0&_nc_cat=106", // Replace with your image path
                        fit: BoxFit.cover, // Ensures the image covers the circle
                      ),
                    ),
                  ),
                  // Edit icon
                  Positioned(
                    bottom: 0, // Position the icon at the bottom of the image
                    right: 0,  // Position the icon at the right of the image
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonColor, // Background color for the icon
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20, // Adjust the size of the icon
                      ),
                      padding: EdgeInsets.all(8), // Adjust the padding to size the icon circle
                    ),
                  ),
                ],
              ),
            ), // Add space for the circular image
            // Column below the circular image
            Padding(
              padding: const EdgeInsets.all(16.0), // Padding around the column content
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: Get.height * 0.18,
                    ),
                    Text(
                      textDirection: TextDirection.rtl,
                      'الأسم كامل',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    // Add TextFormField
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: 'ايهاب ابراهيم',
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
                          color: Colors.black45
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    // Add TextFormField
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: 'Ehab@gmail.com',
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
                          color: Colors.black45
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    // Add TextFormField
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: '***********',
                          suffixIcon: Icon(Icons.remove_red_eye_outlined)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: Get.height * 0.06,
                        width: Get.width,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const ChangePass());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor),
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor),
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: buttonColor,width: 2),
                              backgroundColor: Colors.white),
                          child: Text(
                            "ازاله الحساب",
                            style:  TextStyle(
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
          ],
        ),

    );
  }
}
