import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_view/sign_in_view.dart';


class OnBording extends StatefulWidget {


  @override
  State<OnBording> createState() => _OnBordingState();
}

class _OnBordingState extends State<OnBording> {
   List<String> imgList = [
    'images/onboarding1.jpg',
    'images/onboarding2.jpg',
    'images/onboarding3.jpg',
  ];

  int _currentIndex = 0;
  PageController _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  void _onNextButtonPressed() {
    if (_currentIndex < imgList.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Get.to( SignIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imgList.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  imgList[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          // Positioned(
          //     top: 60,
          //     left: 0,
          //     right: 0,
          //     child: Column(
          //       children: [
          //         Text("مرحبا!",textDirection: TextDirection.rtl,
          //           style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),),
          //         // SizedBox(
          //         //   height: Get.height * 0.03,
          //         // ),
          //         Text("نحن سعداء بتواجدك في متجر MYD",textDirection: TextDirection.rtl,
          //             style: TextStyle(fontSize: 20,color: Colors.white)),
          //
          //       ],
          //     )
          // ),
          Positioned(
              bottom: 40,
              left: 0,
              right: 250,
              child: TextButton(onPressed: (){
                Get.to(SignIn());
              }, child: Text("تخطي",textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)))
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.white
                            : Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 40,
              left: 250,
              right: 0,
              child: TextButton(onPressed: (){
                _onNextButtonPressed();
              }, child: Text("التالي",textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)))
          ),
        ],
      ),
    );
  }
}
