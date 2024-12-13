// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/auth_controller.dart';

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

  bool checkValidation() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade200,
                              )),
                          child: const Center(
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Login to Your Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Please login to access your Shiny account'),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Email adress or phone number',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please fill this field';
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
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        hintText: 'Enter your Email or phone number',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: SizedBox(
                            height: 10,
                            child: Image.asset(
                              'assets/sms.png',
                            )),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please fill this field';
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: Image.asset('assets/lock.png'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
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
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      if (checkValidation()) {
                        final authService = Provider.of<AuthServiceAdmin>(context, listen: false);
                        authService.login(_emailController.text, _passController.text, context);
                      } else {
                        checkValidation();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20.0),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Divider(
                  //         color: Colors.grey.shade200,
                  //         height: 1.5,
                  //       ),
                  //     ),
                  //     const Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //       child: Text(
                  //         'Or login using',
                  //         style: TextStyle(
                  //           fontSize: 14.0,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Divider(
                  //         color: Colors.grey.shade200,
                  //         height: 1.5,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 40.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const SocialIcon(icon: 'assets/Mask Group 3.svg'),
                  //     const SizedBox(width: 20.0),
                  //     GestureDetector(
                  //       onTap: () {
                  //         Provider.of<AuthService>(context,listen: false).signInWithGoogle(context);
                  //       },
                  //       child: const SocialIcon(icon: 'assets/Mask Group 1.svg')),
                  //   ],
                  // ),
                  // const SizedBox(height: 20.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text("Don't have an account?"),
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.of(context).push(MaterialPageRoute(
                  //             builder: (ctx) => const SignupScreen()));
                  //       },
                  //       child: const Text(
                  //         'Sign Up',
                  //         style: TextStyle(
                  //           color: defaultColor,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
