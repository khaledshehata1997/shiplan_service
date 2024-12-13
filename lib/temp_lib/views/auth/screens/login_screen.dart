// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/views/splash_screen.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/auth/screens/signup_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;

  bool checkValidation() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        title: Text(S.of(context).login),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).emailOrPhone,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context).Pleasefillthis_field;
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _emailController.text = newValue!;
                  },
                  cursorColor: Colors.black,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 20.0.w),
                      hintText: S.of(context).enterEmailOrPhoneNumber,
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: SizedBox(
                          height: 10.h,
                          child: Image.asset(
                            'assets/sms.png',
                          )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      )),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  S.of(context).password,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context).Pleasefillthis_field;
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _passController.text = newValue!;
                  },
                  cursorColor: Colors.black,
                  obscureText: _obscureText,
                  obscuringCharacter: '*',
                  controller: _passController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 20.0.w),
                    hintText: S.of(context).enterYourPassword,
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: Image.asset('assets/lock.png'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0.r),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0.r),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0.r),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0.r),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          S.of(context).forgetPassword,
                          style: const TextStyle(color: Colors.black),
                        )),
                  ],
                ),
                InkWell(
                    borderRadius: BorderRadius.circular(30.r),
                    onTap: () async {
                      if (checkValidation()) {
                        final authService = Provider.of<AuthService>(context, listen: false);
                        setState(() {
                          isLoading = true;
                        });
                        final input = _emailController.text.trim();
                        final bool isEmail = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(input);
                        final bool isPhoneNumber = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(input);

                        if (isEmail) {
                          await authService.login(input, _passController.text, context);
                        } else if (isPhoneNumber) {
                          await authService.loginWithPhoneNumber(
                              context, input, _passController.text);
                        } else {
                          showTopSnackBar(
                            context,
                            S.of(context).please_enter_a_valid_email_or_phone_number,
                            Icons.info,
                            defaultColor,
                            const Duration(seconds: 4),
                          );
                        }
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        checkValidation();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      width: double.infinity,
                      // Dynamically adjust the height based on screen size
                      height: MediaQuery.of(context).size.width > 600
                          ? 100.0.h
                          : 60.0.h, // 80.h for tablets, 60.h for phones
                      decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.circular(30.0.r),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                S.of(context).login,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )),
                SizedBox(height: 20.0.h),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Divider(
                //         color: Colors.grey.shade200,
                //         height: 1.5,
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //       child: Text(
                //         S.of(context).OrLogin,
                //         style: TextStyle(
                //           fontSize: 14.0.sp,
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Divider(
                //         color: Colors.grey.shade200,
                //         height: 1.5.h,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 40.0.h),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     if (Platform.isIOS) ...[
                //       GestureDetector(
                //         onTap: () {
                //           Provider.of<AuthService>(context, listen: false)
                //               .signInWithApple(context);
                //         },
                //         child: SocialIcon(icon: 'assets/Mask Group 3.svg'),
                //       ),
                //       SizedBox(width: 20.0.w),
                //     ],
                //     GestureDetector(
                //         onTap: () {
                //           Provider.of<AuthService>(context, listen: false)
                //               .signInWithGoogle(context);
                //         },
                //         child: const SocialIcon(
                //             icon: 'assets/Mask Group 1.svg')),
                //   ],
                // ),
                // SizedBox(height: 20.0.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).dontHaveAnAccount),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) => const SignupScreen()));
                      },
                      child: Text(
                        S.of(context).signup,
                        style: const TextStyle(
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You Are Admin ?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) => const SplashScreen()));
                      },
                      child: const Text(
                        "Login As Admin",
                        style: TextStyle(
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
