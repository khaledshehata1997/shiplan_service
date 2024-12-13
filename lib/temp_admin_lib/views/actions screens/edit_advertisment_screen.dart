// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/advertisments_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_advertisment_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class EditAdvertismentScreen extends StatefulWidget {
  const EditAdvertismentScreen({super.key, required this.advertismentId, required this.image});
  final String advertismentId;
  final String image;

  @override
  State<EditAdvertismentScreen> createState() => _EditAdvertismentScreenState();
}

class _EditAdvertismentScreenState extends State<EditAdvertismentScreen> {
  File? image;
  String imageUrl = '';
  bool showWarningText = false;
  bool isLoading = false;
  @override
  void initState() {
    imageUrl = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Advertisment',
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
                          imageUrl = Provider.of<AdImageController>(context, listen: false)
                              .getBase64Image!;
                        });

                        await Provider.of<AdvertismentsController>(context, listen: false)
                            .updateAdvertisment(
                          advertismentId: widget.advertismentId,
                          imageUrl: imageUrl,
                        );

                        showTopSnackBar(
                          context,
                          "Advertisment Updated!",
                          Icons.check_circle,
                          defaultColor,
                          const Duration(seconds: 4),
                        );
                        setState(() {
                          // showWarningText = !showWarningText;
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
