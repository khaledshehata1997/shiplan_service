// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/notification_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class PushNotificationScreen extends StatefulWidget {
  const PushNotificationScreen({super.key});

  @override
  State<PushNotificationScreen> createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NotificationController>(context, listen: false).getAccessToken();
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
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
      labelText: labelText, // Dynamic labelText
      labelStyle: TextStyle(color: Colors.grey.shade400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: inputDecoration('Title'),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _messageController,
              decoration: inputDecoration('Message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: !isLoading
                  ? () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await Provider.of<NotificationController>(context, listen: false)
                            .sendNotification(_titleController.text, _messageController.text);

                        if (!mounted) return;
                        showTopSnackBar(
                          context,
                          "Notification has been sent!",
                          Icons.check_circle,
                          defaultColor,
                          const Duration(seconds: 4),
                        );
                      } catch (e) {
                        // Handle error, maybe show an error message
                        log('Error: $e');
                      } finally {}
                      setState(() {
                        isLoading = false;
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
