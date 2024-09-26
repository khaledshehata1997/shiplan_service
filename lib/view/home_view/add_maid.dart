import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../view_model/maid_model/maid_model.dart';

class AddMaidScreen extends StatefulWidget {
  const AddMaidScreen({super.key});

  @override
  State<AddMaidScreen> createState() => _AddMaidScreenState();
}

class _AddMaidScreenState extends State<AddMaidScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form input fields
  String name = '';
  int age = 0;
  String country = '';
  File? imageFile;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Method to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // Add Maid to Firestore
  Future<void> _addMaid() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Upload image to Firebase Storage if the image is selected
        String imageUrl = '';
        if (imageFile != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('maids/${Uuid().v4()}'); // Generate unique file name

          // Upload file to Firebase Storage
          await storageRef.putFile(imageFile!);

          // Get the download URL of the uploaded image
          imageUrl = await storageRef.getDownloadURL();
        }

        // Create the Maid object with imageUrl
        MaidModel newMaid = MaidModel(
          id: Uuid().v4(),
          name: name,
          age: age,
          country: country,
          imageUrl: imageUrl,
        );

        // Firestore reference to 'maids' collection or specific document
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('maids').doc('maidList');

        // First, get the current list of maids
        DocumentSnapshot docSnapshot = await documentReference.get();

        // If the document exists, retrieve the current list of maids
        List<dynamic> maidsList = [];
        if (docSnapshot.exists && docSnapshot.data() != null) {
          maidsList =
              (docSnapshot.data() as Map<String, dynamic>)['maidService'] ?? [];
        }

        // Add the new maid to the list
        maidsList.add(newMaid.toMap());

        // Update the document with the new list of maids
        await documentReference.set({
          'maidService': maidsList,
        }, SetOptions(merge: true)).then((value) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Maid added successfully!')),
          );
        }).catchError((error) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add maid: $error')),
          );
        });

        // Clear form fields or navigate back
        _formKey.currentState!.reset();
        setState(() {
          imageFile = null;
        });
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding maid: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضف خادمة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name input field
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),

              // Age input field
              TextFormField(
                decoration: InputDecoration(labelText: 'السن'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'من فضلك ادخل السن';
                  }
                  return null;
                },
                onSaved: (value) {
                  age = int.parse(value!);
                },
              ),

              // Country input field
              TextFormField(
                decoration: InputDecoration(labelText: 'الدولة'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك ادخل الدولة';
                  }
                  return null;
                },
                onSaved: (value) {
                  country = value!;
                },
              ),

              // Image picker widget
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    imageFile != null
                        ? Image.file(
                            imageFile!,
                            height: 150,
                          )
                        : Text('لا يوجد صورة'),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('التقاط صورة'),
                    ),
                  ],
                ),
              ),

              // Add Maid button
              ElevatedButton(
                onPressed: _addMaid,
                child: Text('اضف خادمة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
