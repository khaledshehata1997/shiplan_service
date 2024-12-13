// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_category_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_advertisment_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen(
      {super.key,
      required this.categoryId,
      required this.name,
      required this.nameAr,
      required this.image});
  final String categoryId;
  final String name;
  final String nameAr;
  final String image;

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  File? image;
  final _categoryName = TextEditingController();
  final _categoryNameAr = TextEditingController();
  String imageUrl = '';
  bool showWarningText = false;
  bool isLoading = false;

  @override
  void initState() {
    _categoryName.text = widget.name;
    _categoryNameAr.text = widget.nameAr;
    imageUrl = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Text('Name Category'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _categoryName,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        labelText: 'enter name',
                        labelStyle: TextStyle(color: Colors.grey.shade400)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Text('Arabic Name Category'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _categoryNameAr,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        labelText: 'enter name',
                        labelStyle: TextStyle(color: Colors.grey.shade400)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Upload Photo'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<AdImageController>(
                    builder: (context, imageProvider, _) {
                      return GestureDetector(
                        onTap: () async {
                          await imageProvider.pickImage(context);
                          setState(() {
                            image = imageProvider.getImage;
                          });
                        },
                        child: Container(
                            height: 120,
                            width: 335,
                            decoration: DottedDecoration(
                              color: defaultColor,
                              shape: Shape.box,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: image == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.memory(
                                      base64Decode(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ))),
                      );
                    },
                  ),
                  showWarningText
                      ? const Column(children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'You have nothing to update',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ])
                      : const SizedBox()
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: !isLoading
                    ? () async {
                        setState(() {
                          isLoading = true;
                        });
                        Map<String, dynamic> updateData = {};

                        // Upload image if not null
                        if (image != null) {
                          setState(() {
                            imageUrl = Provider.of<AdImageController>(context, listen: false)
                                .getBase64Image!;
                            updateData['image'] = imageUrl;
                          });
                        }

                        // Update nameEn if not empty
                        if (_categoryName.text.trim().isNotEmpty) {
                          updateData['nameEn'] = _categoryName.text.trim();
                        }

                        // Update nameAr if not empty
                        if (_categoryNameAr.text.trim().isNotEmpty) {
                          updateData['nameAr'] = _categoryNameAr.text.trim();
                        }

                        if (updateData.isNotEmpty) {
                          Provider.of<AddCategoryController>(context, listen: false)
                              .editCategory(widget.categoryId, updateData);
                          showTopSnackBar(
                            context,
                            "Category Updated!",
                            Icons.check_circle,
                            defaultColor,
                            const Duration(seconds: 4),
                          );
                          setState(() {
                            image = null;
                            _categoryName.clear();
                            _categoryNameAr.clear();
                          });
                        } else {
                          // setState(() {
                          //   showWarningText = true;
                          // });
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100.0,
        left: MediaQuery.of(context).size.width * 0.30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
