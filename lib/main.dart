import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiplan_service/view/auth_view/splash_view.dart';
import 'view/onboarding_view/onboarding_view.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}

