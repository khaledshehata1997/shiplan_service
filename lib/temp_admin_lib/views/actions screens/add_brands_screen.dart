// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_brand_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_advertisment_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class AddBrandsScreen extends StatefulWidget {
  const AddBrandsScreen({super.key});

  @override
  State<AddBrandsScreen> createState() => _AddBrandsScreenState();
}

class _AddBrandsScreenState extends State<AddBrandsScreen> {
  File? image;
  final _brandName = TextEditingController();
  final _brandNameAr = TextEditingController();
  String imageUrl = '';
  bool isLoading = false;
  bool isBrandAdded = false;
  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
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
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey.shade400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Brands',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(isBrandAdded);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      Text('Name Brand'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(controller: _brandName, decoration: inputDecoration('enter name')),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Text('Arabic Name Brand'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(controller: _brandNameAr, decoration: inputDecoration('enter name')),
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
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: !isLoading
                    ? () async {
                        if (_brandName.text.trim().isEmpty &&
                            image == null &&
                            _brandNameAr.text.trim().isEmpty) {
                          showTopSnackBar(
                            context,
                            "all fileds required",
                            Icons.warning,
                            defaultColor,
                            const Duration(seconds: 4),
                          );
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          setState(() {
                            imageUrl = Provider.of<AdImageController>(context, listen: false)
                                .getBase64Image!;
                          });
                          Provider.of<AddBrandController>(context, listen: false)
                              .addBrand(_brandName.text, imageUrl, _brandNameAr.text);
                          setState(() {
                            isLoading = false;
                          });
                          showTopSnackBar(
                            context,
                            "Brand added",
                            Icons.check_circle,
                            defaultColor,
                            const Duration(seconds: 4),
                          );
                          setState(() {
                            isBrandAdded = true;
                            _brandName.clear();
                            _brandNameAr.clear();
                            image = null;
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
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
