import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class ImagePickerController with ChangeNotifier {
  File? _image;
  File? get getImage => _image;
  String _imageUrl = '';
  String get getImageUrl => _imageUrl;
  List<String> downloadUrls = [];
  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = File(image.path);
      notifyListeners();
    } else {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
        context,
        "there is no image selected",
        Icons.check_circle,
        defaultColor,
        const Duration(seconds: 4),
      );
    }
  }

  Future<void> uploadImage(File pickedFile, String name) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('categories_images').child('$name.jpg');

    await storageRef.putFile(pickedFile);
    _imageUrl = await storageRef.getDownloadURL();
    notifyListeners();
  }
}
