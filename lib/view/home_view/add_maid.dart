import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiplan_service/constant/counteries.dart';
import 'package:shiplan_service/view_model/maid_model/maid_model.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart'; // Import the file_picker package

class AddMaidScreen extends StatefulWidget {
  const AddMaidScreen({super.key});

  @override
  State<AddMaidScreen> createState() => _AddMaidScreenState();
}

class _AddMaidScreenState extends State<AddMaidScreen> {
  final _formKey = GlobalKey<FormState>();
  CounteriesModel slectedCountery = counteriesList.first;

  // Form input fields
  String name = '';
  int age = 0;
  File? imageFile;
  File? cvFile; // Added CV file variable
  bool isLoading = false; // Loading state

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

  // Method to pick CV file using file_picker
  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        cvFile = File(result.files.single.path!);
      });
    }
  }

  // Add Maid to Firestore
  Future<void> _addMaid() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true; // Start loading
      });

      String id = const Uuid().v4();
      try {
        // Upload image to Firebase Storage if the image is selected
        String imageUrl = '';
        if (imageFile != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('maids/$id-image'); // Generate unique file name for image

          // Upload file to Firebase Storage
          await storageRef.putFile(imageFile!);

          // Get the download URL of the uploaded image
          imageUrl = await storageRef.getDownloadURL();
        }

        // Upload CV to Firebase Storage if the CV is selected
        String cvUrl = '';
        if (cvFile != null) {
          final cvStorageRef = FirebaseStorage.instance
              .ref()
              .child('maids/$id-cv'); // Generate unique file name for CV

          // Upload CV file to Firebase Storage
          await cvStorageRef.putFile(cvFile!);

          // Get the download URL of the uploaded CV
          cvUrl = await cvStorageRef.getDownloadURL();
        }

        // Create the Maid object with imageUrl and cvUrl
        MaidModel newMaid = MaidModel(
          id: id,
          name: name,
          age: age,
          country: slectedCountery.name,
          imageUrl: imageUrl,
          cvUrl: cvUrl,
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
            const SnackBar(content: Text('Maid added successfully!')),
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
          cvFile = null; // Clear CV file after upload
          isLoading = false; // Stop loading
        });
      } catch (e) {
        setState(() {
          isLoading = false; // Stop loading on error
        });
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
        title: const Text('اضف خادمة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name input field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
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
                decoration: const InputDecoration(labelText: 'السن'),
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
              const SizedBox(height: 20),
              DropdownMenu<CounteriesModel>(
                expandedInsets: const EdgeInsets.symmetric(horizontal: 10),
                initialSelection: counteriesList.first,
                onSelected: (value) {
                  setState(() {
                    slectedCountery = value!;
                  });
                },
                dropdownMenuEntries: counteriesList
                    .map<DropdownMenuEntry<CounteriesModel>>((value) {
                  return DropdownMenuEntry<CounteriesModel>(
                      value: value, label: value.name);
                }).toList(),
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
                        : const Text('لا يوجد صورة'),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('التقاط صورة'),
                    ),
                  ],
                ),
              ),

              // CV picker widget
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    cvFile != null
                        ? Text('CV selected: ${cvFile!.path.split('/').last}')
                        : const Text('لا يوجد CV'),
                    ElevatedButton.icon(
                      onPressed: _pickCV,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('رفع السيرة الذاتية'),
                    ),
                  ],
                ),
              ),

              // Add Maid button or Loading widget
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _addMaid,
                      child: const Text('اضف خادمة'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
