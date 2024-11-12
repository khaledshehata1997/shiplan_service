import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:shiplan_service/view/auth_view/sign_in_view.dart';

import '../onboarding_view/onboarding_view.dart';

class SplashView extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

late bool first;
firstTime() async {
  bool firstRun = await IsFirstRun.isFirstRun();
  first = firstRun;
}

class _MyHomePageState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    firstTime();
    Timer(const Duration(seconds: 4), () => Get.to(SignIn()));
    //  Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) =>  OnBording())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Container(
            width: Get.width * .4,
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/splash.png'),
                Text(
                  'شبلان للاستقدام',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'جميع الحقوق محفوظه',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                )
              ],
            ))),
      ),
    );
  }
}
