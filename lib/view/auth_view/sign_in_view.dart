import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shiplan_service/view/home_view/home_view.dart';
import 'package:shiplan_service/view/home_view/nav_bar_view.dart';

import '../../constants.dart';
import '../../view_model/auth_model/auth_view_model.dart';
import 'sign_up_view.dart';
import 'verification_view.dart';

class SignIn extends StatefulWidget {

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var controller = Get.put(AuthViewModel());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  @override
  void initState() {
    super.initState();
  }
  Future<void> _checkUserProfile() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();

    if (userDoc.exists) {
      // User data exists
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('name') && data.containsKey('email')) {
        // User profile information is available
        Get.offAll(const HomeView());
      }
      // else {
      //   // User profile information is incomplete
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => CompleteProfilePage(user: user)),
      //   );
      // }
    }
    // else {
    //   // User document does not exist
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => CompleteProfilePage(user: user)),
    //   );
    // }
  }


  var isloading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:GetBuilder<AuthViewModel>(
        init: AuthViewModel(),
        builder: (context) {
          return Stack(
                children: [
                  Container(
                    height: Get.height,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage("images/background.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.white.withOpacity(.00001),

                    ),
                  ),
                  SizedBox(
                    width: Get.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * .08,
                          ),


                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              //  color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const []),
                            width: Get.width * .9,
                            // height: Get.height * .55,
                            child: Form(
                              key: formKey,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Column(
                                  children: [
                                 Image.asset('images/auth.png'),

                                    SizedBox(
                                      height: Get.height * .03,
                                    ),
                                    Text(

                                      'تسجيل الدخول',style: TextStyle(color: Colors.white,fontSize: 22,
                                    fontWeight: FontWeight.bold

                                      ,
                                    ),),
                                    SizedBox(
                                      height: Get.height * .03,
                                    ),
                                    TextFormField(
                                      onChanged: (value) {
                                       controller.email = value;
                                      },
                                      decoration:  InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'البريد الالكتروني',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: buttonColor,width: 2.0),
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter email';
                                        }
                                        // regx
                                        const pattern =
                                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
                                        final regExp = RegExp(pattern);
                                        if (!regExp.hasMatch(value)) {
                                          return 'Please enter valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 13,
                                    ),
                                    TextFormField(
                                      onChanged: (value) {
                                        controller.password = value;
                                      },
                                      decoration:  InputDecoration(
                                        suffixIcon:Icon(Icons.remove_red_eye_outlined),
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'كلمة المرور',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: buttonColor,width: 2.0),
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        // if have white space
                                        if (value.contains(' ')) {
                                          return 'password must not contain white space';
                                        }
                                        // have to be more than 8 char
                                        if (value.length < 8) {
                                          return 'Password must be more than 8 char';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(const VerificationView());
                                      },
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        child: const Text(
                                          'هل نسيت كلمة السر؟',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              decoration: TextDecoration.underline

                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * .035,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isloading = true;
                                            formKey.currentState!.save();
                                            if (formKey.currentState!.validate()) {
                                              controller.signIn();
                                              isloading = false;
                                            }
                                            isloading = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: buttonColor,
                                            fixedSize:
                                            Size.fromWidth(Get.width * .8)),
                                        child: const Text('تسجيل الدخول',style: TextStyle(color: Colors.white,fontSize: 18
                                            ,fontWeight: FontWeight.bold
                                        ),)),


                                    SizedBox(height: 30,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                       Text('ليس لديك حساب؟',style: TextStyle(color: Colors.white,fontSize: 16
                                          ,
                                        ),),
                                        GestureDetector(
                                          onTap: (){
                                            Get.to(SignUpView());
                                          },
                                          child: Text(

                                            '  إنشاء حساب جديد',style: TextStyle(color: Colors.white,fontSize: 21,
                                            decoration: TextDecoration.underline,fontWeight: FontWeight.bold

                                            ,
                                          ),),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Text('-او سجل باستخدام-',style: TextStyle(color: Colors.black,fontSize: 17
                          //     ,fontWeight: FontWeight.bold
                          // ),),
                          // SizedBox(
                          //   height: Get.height * .01,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //   GestureDetector(
                          //     onTap:() async {
                          //        _signInWithGoogle();
                          //       // Get.off(const HomeView());
                          //     },
                          //     child: Container(
                          //       margin: EdgeInsets.all(10),
                          //       width: 50,
                          //       height: 35,
                          //      // color: Colors.grey,
                          //       child: Image.asset('images/google (1).png'),
                          //     ),
                          //   ) ,
                          //     // GestureDetector(
                          //     //   onTap: ()async {
                          //     //     try {
                          //     //       UserCredential userCredential = await signInWithFacebook();
                          //     //       print(userCredential.user);
                          //     //     } catch (e) {
                          //     //       print(e);
                          //     //     }
                          //     //   },
                          //     //   child: Container(
                          //     //     child: Image.asset('images/facebook.png'),
                          //     //     margin: EdgeInsets.all(10),
                          //     //   width: 50,
                          //     //   height: 35,
                          //     //                            // color: Colors.white,
                          //     //                           ),
                          //     // )
                          //   ],
                          // ),

                        ],
                      ),
                    ),
                  ),
                ],
              );
        }
      ),
    );
  }
}
