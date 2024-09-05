import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shiplan_service/view/auth_view/sign_in_view.dart';


import '../../constants.dart';
import 'sign_up_view.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _SignInState();
}

class _SignInState extends State<VerificationView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // var controller = Get.put(AuthViewModel());
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // User? user;
  // // late VideoPlayerController _controller;
  // Future<void> _signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   user = (await _auth.signInWithCredential(credential)).user;
  //
  //   if (user != null) {
  //     _checkUserProfile();
  //   }
  // }
  //
  // Future<void> _checkUserProfile() async {
  //   DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
  //
  //   if (userDoc.exists) {
  //     // User data exists
  //     Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
  //     if (data != null && data.containsKey('name') && data.containsKey('phone')) {
  //       // User profile information is available
  //       Get.offAll(const HomeView());
  //     } else {
  //       // User profile information is incomplete
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => CompleteProfilePage(user: user)),
  //       );
  //     }
  //   } else {
  //     // User document does not exist
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => CompleteProfilePage(user: user)),
  //     );
  //   }
  // }
  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   if (loginResult.status == LoginStatus.success) {
  //     // Get the AccessToken
  //     final AccessToken accessToken = loginResult.accessToken!;
  //
  //     // Create a credential from the access token
  //     final OAuthCredential facebookAuthCredential =
  //     FacebookAuthProvider.credential(accessToken.tokenString);
  //
  //     // Once signed in, return the UserCredential
  //     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   } else {
  //     throw FirebaseAuthException(
  //       code: loginResult.status.toString(),
  //       message: loginResult.message,
  //     );
  //   }
  // }


  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.asset('videos/vid.mp4')
    //   ..initialize().then((value) {
    //     _controller.play();
    //     _controller.setLooping(false);
    //     setState(() {});
    //   });
  }


  var isloading = false;

  @override
  Widget build(BuildContext context) {
    ValueNotifier userCredential = ValueNotifier('');
    return Scaffold(
      body:Stack(
        children: [
          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          //   child: SizedBox.expand(
          //     child: FittedBox(
          //       fit: BoxFit.cover,
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width,
          //         height: MediaQuery.of(context).size.height,
          //         child: VideoPlayer(_controller),
          //       ),
          //     ),
          //   ),
          // ),
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
                                          'تم تحديث كلمة المرور الخاصه بك بنجاح',
                                          style: TextStyle(
                                              fontSize: 22,

                                              color: Colors.white),
                                        ),
                                       // SizedBox(height: 40,),
                                        ElevatedButton(
                                            onPressed: () {
                                         Get.to(SignIn());
                                                 }
                                              // setState(() {
                                              //   isloading = true;
                                              //   formKey.currentState!.save();
                                              //   if (formKey.currentState!.validate()) {
                                              //     controller.signIn();
                                              //     isloading = false;
                                              //   }
                                              //   isloading = false;
                                              // });
                                            ,
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
                                  // setState(() {
                                  //   isloading = true;
                                  //   formKey.currentState!.save();
                                  //   if (formKey.currentState!.validate()) {
                                  //     controller.signIn();
                                  //     isloading = false;
                                  //   }
                                  //   isloading = false;
                                  // });
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
