// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_category_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_advertisment_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  File? image;
  final _categoryName = TextEditingController();
  final _categoryNameAr = TextEditingController();
  String imageUrl = '';
  bool showWarningText = false;
  bool isLoading = false;
  bool isCategoryAdded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(isCategoryAdded);
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
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: defaultColor,
                                                borderRadius: BorderRadius.circular(10)),
                                            child: SvgPicture.asset('assets/upload 01.svg')),
                                        const Text('Choose file to Upload'),
                                        Text(
                                          'supported format png, jepg',
                                          style: TextStyle(color: Colors.grey.shade400),
                                        )
                                      ],
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
                                'All fields required!',
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
                        if (_categoryName.text.trim().isNotEmpty &&
                            image != null &&
                            _categoryNameAr.text.trim().isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          setState(() {
                            imageUrl = Provider.of<AdImageController>(context, listen: false)
                                .getBase64Image!;
                            showWarningText = false;
                          });
                          Provider.of<AddCategoryController>(context, listen: false)
                              .addCategory(_categoryName.text, _categoryNameAr.text, imageUrl);
                          setState(() {
                            isLoading = false;
                          });

                          showTopSnackBar(
                            context,
                            "Category Added!",
                            Icons.check_circle,
                            defaultColor,
                            const Duration(seconds: 4),
                          );
                          setState(() {
                            isCategoryAdded = true;
                            image = null;
                            _categoryName.clear();
                            _categoryNameAr.clear();
                          });
                        } else {
                          setState(() {
                            showWarningText = !showWarningText;
                          });
                        }
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
                    : const Text(
                        'Save',
                        style: TextStyle(fontSize: 17),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
