// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/auth/screens/login_screen.dart';
import 'package:shiplan_service/temp_lib/views/auth/widgets/verification_bottom_sheet.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/tabs_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService() {
    _user = _auth.currentUser;
  }
  User? _user;

  User? get user => _user;

  bool get isUserLoggedIn => _user != null;

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user; // Store the User object directly

      // Check if the user email is verified
      if (!_user!.emailVerified) {
        // Prompt the user to resend the verification email if not verified
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Email Not Verified'),
            content: const Text(
                'Your email is not verified. Would you like to resend the verification email?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _user!
                        .sendEmailVerification(); // Resend verification email
                    Navigator.of(ctx).pop();
                    showTopSnackBar(
                      context,
                      S
                          .of(context)
                          .Verification_email_sent_Please_check_your_inbox,
                      Icons.info,
                      defaultColor,
                      const Duration(seconds: 4),
                    );
                  } catch (e) {
                    showTopSnackBar(
                      context,
                      'Could not send verification email. Try again later.',
                      Icons.error,
                      Colors.red,
                      const Duration(seconds: 4),
                    );
                  }
                },
                child: Text(
                  S.of(context).Resend_Email,
                ),
              ),
            ],
          ),
        );
        return;
      }

      // If the email is verified, proceed to save the FCM token and navigate to the next screen
      notifyListeners();

      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => const TabsScreen(isLoggedIn: true)),
      );
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        context,
        S.of(context).Something_went_wrong,
        Icons.error,
        Colors.red,
        const Duration(seconds: 4),
      );
    }
  }

  Future<void> signup(String email, String pass, String phoneNumber,
      String username, BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Create user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();

        await firestore.collection('tempUsers').doc(user.uid).set({
          'email': email,
          'phoneNumber': phoneNumber,
          'username': username,
          'buyer': true,
          'password': pass,
          'createdAt': FieldValue.serverTimestamp(),
        });

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
      log(e.message ?? 'no e');
      if (e.message ==
          "The email address is already in use by another account.") {
        showTopSnackBar(
          context,
          S.of(context).theEmailIsAlreadyInUse,
          Icons.check_circle,
          defaultColor,
          const Duration(seconds: 4),
        );
      } else {
        showTopSnackBar(
          context,
          S.of(context).Something_went_wrong,
          Icons.check_circle,
          defaultColor,
          const Duration(seconds: 4),
        );
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await googleSignIn
        .signOut(); // Ensure user signs out to prevent auto sign-in
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        await firestore
            .collection('tempUsers')
            .doc(userCredential.user!.uid)
            .set({
          'email': userCredential.user!.email,
          'phoneNumber': userCredential.user!.phoneNumber,
          'username': userCredential.user!.displayName,
          'buyer': true,
          'password': 'googleUser',
          'createdAt': FieldValue.serverTimestamp(),
        });
        User? user = userCredential.user;

        if (user != null) {
          // Firebase will handle new or existing users

          _user = user;
          notifyListeners();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => const TabsScreen(isLoggedIn: true),
            ),
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
        'Sign-in canceled.',
        Icons.info,
        defaultColor,
        const Duration(seconds: 4),
      );
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      // Ensure the user is logged in
      if (_user == null) {
        showTopSnackBar(
          context,
          'No user is currently logged in.',
          Icons.error,
          Colors.red,
          const Duration(seconds: 4),
        );
        return;
      }

      // Delete user data from Firestore
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('tempUsers').doc(_user!.uid).delete();

      // Delete the user from Firebase Authentication
      await _user!.delete();

      // Optionally, sign out after account deletion
      await logout();
      print("Mostafaaaa");
      // Navigate to the login screen or show a success message
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const LoginScreen()),
      );

      showTopSnackBar(
        context,
        'Account deleted successfully.',
        Icons.check_circle,
        Colors.green,
        const Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showTopSnackBar(
        context,
        S.of(context).Something_went_wrong,
        Icons.error,
        Colors.red,
        const Duration(seconds: 4),
      );
    } catch (e) {
      print(e);
      showTopSnackBar(
        context,
        S.of(context).Something_went_wrong,
        Icons.error,
        Colors.red,
        const Duration(seconds: 4),
      );
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await firestore.collection('tempUsers').doc(user.uid).set({
          'email': user.email ?? 'No Email',
          'phoneNumber': user.phoneNumber,
          'username': user.displayName ?? 'No Username',
          'buyer': true,
          'password': 'appleUser',
          'createdAt': FieldValue.serverTimestamp(),
        });

        _user = user;
        notifyListeners();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const TabsScreen(isLoggedIn: true),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        context,
        S.of(context).Something_went_wrong,
        Icons.error,
        Colors.red,
        const Duration(seconds: 4),
      );
    } catch (error) {
      showTopSnackBar(
        context,
        S.of(context).Sign_In_Canceled,
        Icons.info,
        defaultColor,
        const Duration(seconds: 4),
      );
    }
  }

  Future<void> loginWithPhoneNumber(
      BuildContext context, String phoneNumber, String password) async {
    try {
      final normalizedPhoneNumber = phoneNumber.trim();

      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('tempUsers');

      final QuerySnapshot result = await usersCollection
          .where('phoneNumber', isEqualTo: normalizedPhoneNumber)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        showTopSnackBar(
          context,
          S.of(context).USer_Not_Found,
          Icons.error,
          Colors.red,
          const Duration(seconds: 4),
        );
        return;
      }

      final DocumentSnapshot userDoc = result.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      if (userData['password'] == password) {
        showTopSnackBar(
          context,
          S.of(context).Login_Successful,
          Icons.check,
          Colors.green,
          const Duration(seconds: 4),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const TabsScreen(isLoggedIn: true),
          ),
        );
      } else {
        showTopSnackBar(
          context,
          S.of(context).Password_is_incorrect,
          Icons.error,
          Colors.red,
          const Duration(seconds: 4),
        );
      }
    } catch (e) {
      log('Error logging in: $e');
      showTopSnackBar(
        context,
        S.of(context).An_error_occurred_Please_try_again_later,
        Icons.error,
        Colors.red,
        const Duration(seconds: 4),
      );
    }
  }

  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).Login_required),
          content:
              Text(S.of(context).You_need_to_log_in_to_add_items_to_your_cart),
          actions: [
            TextButton(
              child: Text(S.of(context).Close,
                  style: TextStyle(color: defaultColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).login,
                  style: TextStyle(color: defaultColor)),
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
