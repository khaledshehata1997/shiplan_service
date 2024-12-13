import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

Future<void> handleBackGoroundMessage(RemoteMessage message) async {
  log('message: ${message.notification!.title}');
}

class NotificationController with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? token;
  String accessToken = '';

  Future<void> initializeFCM(BuildContext context) async {
    if (token == null) {
      await _firebaseMessaging.requestPermission();
      token = await _firebaseMessaging.getToken();
      log('FCM Token : $token');
      FirebaseMessaging.onBackgroundMessage(handleBackGoroundMessage);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log('message body: ${message.notification?.body}');
        log('message data: ${message.data}');
        notifyListeners();
        await getAccessToken();
      });
    } else {
      return;
    }

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> sendNotification(String title, String message) async {
    try {
      // Fetch all users from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("tempUsers").get();

      // List to keep track of the tokens of users that received the notification
      List<String> tokens = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          String? role = data['role'];
          String? token = data['fcmToken'];

          // Only process users who are not admins (no role or role is not 'admin')
          if ((role == null || role != 'admin') && token != null) {
            if (!tokens.contains(token)) {
              tokens.add(token);
              await sendPushNotification(accessToken, token, title, message);
            }
          }
        }
      }

      // Store the notification message in Firestore only once
      if (tokens.isNotEmpty) {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('messages').add({
          'title': title,
          'body': message,
          'timestamp': FieldValue.serverTimestamp(),
          'sentToCount': tokens.length, // Optional: Track how many users received the notification
        });
      }
    } catch (e) {
      log('Error sending notification: $e');
    }
  }

  Future<void> sendPushNotification(
      String accessToken, String fcmToken, String title, String body) async {
    final Uri url =
        Uri.parse('https://fcm.googleapis.com/v1/projects/miss-cady-production/messages:send');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, dynamic>{
          'message': <String, dynamic>{
            'token': fcmToken,
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'android': <String, dynamic>{
              'priority': 'high',
            },
          },
        },
      ),
    );

    if (response.statusCode == 200) {
      log('Notification sent successfully');
    } else {
      log('Failed to send notification: ${response.body}');
    }
  }

  Future<void> sendNotificationToUser(
      {required String? userId, required String title, required String message}) async {
    try {
      // Fetch the user's document by userId
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("tempUsers").doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          String? token = data['fcmToken'];

          if (token != null) {
            // Send notification using FCM HTTP API
            await sendPushNotification(accessToken, token, title, message);
          }
        }
      } else {
        log('User with ID $userId does not exist.');
      }
    } catch (e) {
      log('Error sending notification to user: $e');
    }
  }

  Future<void> getAccessToken() async {
    final serviceAccountJson = {};

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes, client);

      client.close();
      accessToken = credentials.accessToken.data;
      notifyListeners();
    } catch (e) {
      log("Error getting access token: $e");
    }
  }

  Future<void> saveFcmToken(String userId, String? fcmToken, String email) async {
    if (fcmToken != null) {
      final QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
          .collection("tempUsers")
          .where("email", isEqualTo: email)
          .get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot data in data.docs) {
          await FirebaseFirestore.instance.collection("tempUsers").doc(data.id).update({
            'fcmToken': fcmToken,
          });
        }
      }
    }
  }
}
