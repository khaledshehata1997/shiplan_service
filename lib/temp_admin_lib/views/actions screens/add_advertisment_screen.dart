// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/advertisments_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class AddAdvertismentScreen extends StatefulWidget {
  const AddAdvertismentScreen({super.key});

  @override
  State<AddAdvertismentScreen> createState() => _AddAdvertismentScreenState();
}

class _AddAdvertismentScreenState extends State<AddAdvertismentScreen> {
  File? image;
  bool showWarningText = false;
  bool isLoading = false;
  bool isAdAdded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advertisment',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(isAdAdded);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
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
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: !isLoading
                    ? () async {
                        if (image != null) {
                          setState(() {
                            isLoading = true;
                          });

                          // Retrieve the Base64 string
                          String? base64Image =
                              Provider.of<AdImageController>(context, listen: false).getBase64Image;

                          if (base64Image != null) {
                            // Save the advertisement with the Base64 image
                            await Provider.of<AdvertismentsController>(context, listen: false)
                                .addAdvertisment(base64Image);

                            // Show success message
                            showTopSnackBar(
                              context,
                              "Advertisement added",
                              Icons.check_circle,
                              defaultColor,
                              const Duration(seconds: 4),
                            );

                            // Reset the state
                            Provider.of<AdImageController>(context, listen: false).resetState();

                            setState(() {
                              isAdAdded = true;
                              image = null; // Clear the local image
                            });
                          } else {
                            showTopSnackBar(
                              context,
                              "Failed to process image. Please try again.",
                              Icons.error,
                              Colors.red,
                              const Duration(seconds: 4),
                            );
                          }
                        } else {
                          setState(() {
                            showWarningText = true;
                          });
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

class AdImageController with ChangeNotifier {
  File? _image;
  String? _base64Image;

  File? get getImage => _image;
  String? get getBase64Image => _base64Image;

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = File(image.path);

      // Convert image to Base64 string
      _base64Image = base64Encode(await _image!.readAsBytes());

      notifyListeners();
    } else {
      showTopSnackBar(
        context,
        "No image selected",
        Icons.error,
        Colors.red,
        const Duration(seconds: 4),
      );
    }
  }

  void resetState() {
    _image = null;
    _base64Image = null;
    notifyListeners();
  }
}
