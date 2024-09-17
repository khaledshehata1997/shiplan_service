import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../view_model/maid_model/maid_model.dart';


class AddMaidScreen extends StatefulWidget {
  const AddMaidScreen({super.key});

  @override
  State<AddMaidScreen>  createState() => _AddMaidScreenState();
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
        // Placeholder for image URL - replace this with actual image upload logic
        String imageUrl = imageFile != null ? imageFile!.path : '';

        // Create the Maid object
        Maid newMaid = Maid(
          id: '', // Firestore will generate this ID
          name: name,
          age: age,
          country: country,
          imageUrl: imageUrl,
        );

        // Add maid to Firestore
        await FirebaseFirestore.instance.collection('maids').add(newMaid.toMap());

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maid added successfully!')),
        );

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
        title: Text('Add Maid'),
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
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
                onSaved: (value) {
                  age = int.parse(value!);
                },
              ),

              // Country input field
              TextFormField(
                decoration: InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a country';
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
                        : Text('No image selected'),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Pick Image'),
                    ),
                  ],
                ),
              ),

              // Add Maid button
              ElevatedButton(
                onPressed: _addMaid,
                child: Text('Add Maid'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
