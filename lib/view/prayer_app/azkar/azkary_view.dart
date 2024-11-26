import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Azkary extends StatefulWidget {
  final File? image;
  const Azkary({super.key, this.image});

  @override
  State<Azkary> createState() => _AzkaryState();
}

class _AzkaryState extends State<Azkary> {
  File? _image;
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath1');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  _openImagePicker() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('imagePath1', pickedFile.path);
    }
  }

  _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'من فضلك اختار صورة',
            textDirection: TextDirection.rtl,
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                child: Text(
                  'اختار',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _openImagePicker();
                  _loadImage();
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          onPressed: () => _showImagePickerDialog(context),
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/back ground2.jpeg'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(1),
                color: Colors.white,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Row(
                      //   children: [
                      //     GestureDetector(
                      //       // onTap: ()async{
                      //       //   final userData = await getUserData();
                      //       //   Get.off(Profile(username: '${userData['username']}'
                      //       //     , email: '${userData['email']}',));
                      //       // },
                      //       child: CircleAvatar(
                      //         radius: 20,
                      //         backgroundColor: Colors.grey.shade400,
                      //         child: Image.asset(
                      //           'icons/img_1.png',
                      //           width: 20,
                      //           height: 20,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     // CircleAvatar(
                      //     //   child: Icon(Icons.notifications_none),
                      //     //   backgroundColor: Colors.grey.shade400,
                      //     //   radius: 20,
                      //     // ),
                      //     SizedBox(
                      //       width: 15,
                      //     ),
                      //     CircleAvatar(
                      //       radius: 20,
                      //       child: Image.asset(
                      //         'icons/img.png',
                      //         width: 20,
                      //         height: 20,
                      //       ),
                      //       backgroundColor: Colors.grey.shade400,
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'images/back ground2.jpeg',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'اذكاري',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                SizedBox(
                  height: Get.height * 0.7,
                  width: Get.width,
                  child: Center(
                    child: _image == null
                        ? Text('قم بأختيار صورة للعرض')
                        : Image.file(
                            _image!,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
