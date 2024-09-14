import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/firebase_options.dart';
import 'package:shiplan_service/view/auth_view/splash_view.dart';
import 'package:shiplan_service/view_model/auth_service.dart';
import 'view/onboarding_view/onboarding_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp( MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AdminProvider()),
  ],
      child: const MyApp())
  );

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

