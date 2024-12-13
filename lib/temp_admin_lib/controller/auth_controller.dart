// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/notification_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/auth/screens/login_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/auth/widgets/verification_bottom_sheet.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/home_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/drawer_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class AuthServiceAdmin with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService() {
    _user = _auth.currentUser;
  }

  User? _user;

  User? get user => _user;

  bool get isUserLoggedIn => _user != null;

  Future<void> login(String email, String password, BuildContext context) async {
    final fcmToken = Provider.of<NotificationController>(context, listen: false).token;
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;

      if (_user != null) {
        var userRef = FirebaseFirestore.instance.collection("tempUsers").doc(_user!.uid);

        var userDoc = await userRef.get();
        if (userDoc.exists) {
          String role = userDoc.data()?['role'] ?? '';
          String? existingFcmToken = userDoc.data()?['fcmToken'];

          if (role == 'admin') {
            // Only update the fcmToken if it's different or null
            if (existingFcmToken == null || existingFcmToken != fcmToken) {
              await userRef.set(
                {'fcmToken': fcmToken, 'role': 'admin'},
                SetOptions(merge: false),
              );
            }

            notifyListeners();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DrawerScreen()),
              (route) => false,
            );
          } else {
            showTopSnackBar(
              context,
              'You do not have admin privileges!',
              Icons.error,
              Colors.red,
              const Duration(seconds: 4),
            );
          }
        } else {
          showTopSnackBar(
            context,
            'User data not found!',
            Icons.error,
            Colors.red,
            const Duration(seconds: 4),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      showTopSnackBar(
        context,
        e.message ?? 'Something went wrong!',
        Icons.error,
        Colors.red,
        const Duration(seconds: 4),
      );
    }
  }

  Future<void> signup(
      String email, String pass, String phoneNumber, String username, BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final notificationProvider = Provider.of<NotificationController>(context, listen: false);

    try {
      // Create user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();

        await firestore.collection("tempUsers").doc(user.uid).set({
          'email': email,
          'phoneNumber': phoneNumber,
          'username': username,
          'buyer': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        notificationProvider.saveFcmToken(_user!.uid, notificationProvider.token, user.email!);

        notifyListeners();

        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const VerificationBottomSheet(),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        context,
        e.message ?? 'Something went wrong!',
        Icons.check_circle,
        defaultColor,
        const Duration(seconds: 4),
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final notificationProvider = Provider.of<NotificationController>(context, listen: false);

    await googleSignIn.signOut(); // Ensure user signs out to prevent auto sign-in

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      try {
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          DocumentSnapshot userDoc =
              await FirebaseFirestore.instance.collection("tempUsers").doc(user.uid).get();

          if (!userDoc.exists) {
            await FirebaseFirestore.instance.collection("tempUsers").doc(user.uid).set({
              'email': user.email,
              'phoneNumber': user.phoneNumber ?? '',
              'username': user.displayName ?? '',
              'buyer': false,
              'createdAt': FieldValue.serverTimestamp(),
            });
          }

          _user = user;
          notificationProvider.saveFcmToken(_user!.uid, notificationProvider.token, user.email!);
          notifyListeners();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        showTopSnackBar(
          context,
          e.message ?? 'Something went wrong!',
          Icons.check_circle,
          defaultColor,
          const Duration(seconds: 4),
        );
      }
    } else {
      showTopSnackBar(
        context,
        "Sign-in canceled",
        Icons.check_circle,
        defaultColor,
        const Duration(seconds: 4),
      );
    }
  }

  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to log in to add items to your cart.'),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: defaultColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login', style: TextStyle(color: defaultColor)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
