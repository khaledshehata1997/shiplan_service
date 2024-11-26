import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/firebase_options.dart';
import 'package:shiplan_service/view/auth_view/sign_in_view.dart';
import 'package:shiplan_service/view/home_view/nav_bar_view.dart';
import 'package:shiplan_service/view/prayer_app/nav_bar_view.dart';
import 'package:shiplan_service/view_model/auth_model/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AdminProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var user = FirebaseAuth.instance.currentUser;
  Future<bool> showShiblan() async {
    final DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection("navigation")
        .doc("5VzEGVZ6A8vBIxJbUQOX")
        .get();
    return data.data()!['showShiblan'];
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: showShiblan(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const SizedBox();
            }
            return snapshot.data!
                ? user == null
                    ? SignIn()
                    : const NavBarView()
                : PrayerNavBarView2();
          }),
    );
  }
}
