import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shiplan_service/view/auth_view/sign_in_view.dart';


import '../../constants.dart';
import 'sign_up_view.dart';
String formatFirebaseError(FirebaseAuthException exception) {
  String message = '';
  switch (exception.code) {
    case 'invalid-email':
      message = 'Invalid email address';
      break;
    case 'user-not-found':
      message = 'User not found';
      break;
    case 'wrong-password':
      message = 'Wrong password';
      break;
    case 'email-already-in-use':
      message = 'Email already in use';
      break;
    case 'weak-password':
      message = 'Password is too weak';
      break;
    case 'too-many-requests':
      message = 'Too many requests, please try again later';
      break;
    default:
      message = 'Something went wrong';
  }
  return message;
}
class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _SignInState();
}

class _SignInState extends State<VerificationView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;
  String error = '';
  Future sendResetLink() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        setState(() {
          isLoading = false;
        });
        Get.defaultDialog(
            backgroundColor: Colors.black45,
            content: Container(
              width: Get.width*.7,
              height: Get.height*.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.done_outline,color: Colors.white,size: 40,),
                  const Text(
                    textDirection: TextDirection.rtl,
                    'تم ارسال رساله اعاده تعيين كلمه السر الي بريدك الألكتروني',
                    style: TextStyle(
                        fontSize: 22,

                        color: Colors.white),
                  ),
                  // SizedBox(height: 40,),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(SignIn());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          fixedSize:
                          Size.fromWidth(Get.width * .8)),
                      child: const Text('عودة',style: TextStyle(color: Colors.white,fontSize: 18
                          ,fontWeight: FontWeight.bold
                      ),)),
                ],
              ),
              //  color: Colors.black45,
            )
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
          error = e.toString();
        });
        // show error message
        Get.snackbar('Error', formatFirebaseError(e),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      } catch (e) {
        setState(() {
          isLoading = false;
          error = e.toString();
        });
        Get.snackbar('Error', error,
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }


  var isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
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
            child: ClipRRect( // make sure we apply clip it properly
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(.1),

                ),
              ),
            ),
          ),
          SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Get.height * .15,
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
                            Container(
                              child: Image.asset('images/verified.png'),
                              width: Get.width*.8,
                              height: Get.height*.2,
                            ),
                            SizedBox(
                              height: Get.height * .06,
                            ),
                            const Text(
                              'تحقق من هويتك',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              'ادخل البريد الالكتروني لتتلقي رمز اعاده التعيين',
                              style: TextStyle(
                                  fontSize: 16,

                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: Get.height * .03,
                            ),
                            TextFormField(
                              controller: emailController,
                              onChanged: (value) {
                                //  controller.email = value;
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

                            SizedBox(
                              height: Get.height * .03,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  sendResetLink();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    fixedSize:
                                    Size.fromWidth(Get.width * .8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('إرسال الرمز',style: TextStyle(color: Colors.white,fontSize: 18
                                        ,fontWeight: FontWeight.bold
                                    ),),
                                    Icon(Icons.arrow_forward,color: Colors.white,),

                                  ],
                                )),

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
      ),
    );
  }
}
