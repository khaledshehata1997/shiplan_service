// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_support_num_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class AddSupportNumScreen extends StatefulWidget {
  const AddSupportNumScreen({super.key});

  @override
  State<AddSupportNumScreen> createState() => _AddSupportNumScreenState();
}

class _AddSupportNumScreenState extends State<AddSupportNumScreen> {
  final _valueController = TextEditingController();
  bool isLoading = false;
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
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey.shade400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support number',
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('Enter Value')],
                    ),
                    TextField(
                      controller: _valueController,
                      decoration: inputDecoration('Enter the value'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Consumer<AddSupportNumController>(
                  builder: (context, addSupportNumController, child) {
                    return addSupportNumController.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: !isLoading
                                ? () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (_valueController.text.trim().isNotEmpty) {
                                      await addSupportNumController
                                          .addSupportNumber(_valueController.text);
                                      showTopSnackBar(
                                        context,
                                        "Support number added successfully",
                                        Icons.check_circle,
                                        defaultColor,
                                        const Duration(seconds: 4),
                                      );
                                    } else {
                                      showTopSnackBar(
                                        context,
                                        "Field is required",
                                        Icons.warning,
                                        Colors.red,
                                        const Duration(seconds: 4),
                                      );
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: defaultColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Save'),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
