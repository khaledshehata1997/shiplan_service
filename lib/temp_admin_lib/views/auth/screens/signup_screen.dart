// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/auth_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/auth/widgets/social_icon.dart';
import 'package:shiplan_service/temp_admin_lib/views/auth/widgets/textfield_signup.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
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
            padding: const EdgeInsets.all(15.0),
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
                          Navigator.pop(context);
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
                    'Creat New Account',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Please create account first before enjoy the features',
                    style: TextStyle(color: Color.fromARGB(255, 133, 131, 131)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextfieldSignup(
                    controller: _userNameController,
                    hintText: 'Enter your username',
                    icon: Icons.person_outline,
                    image: 'assets/user.png',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Email address',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextfieldSignup(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    icon: Icons.email_outlined,
                    image: 'assets/sms.png',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Phone number',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextfieldSignup(
                    controller: _phoneNumberController,
                    hintText: 'Enter your phone number',
                    icon: Icons.phone_outlined,
                    image: 'assets/call.png',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextfieldSignup(
                    obscureText: _obscureText,
                    controller: _passController,
                    hintText: 'Enter your password',
                    icon: Icons.lock_outline,
                    image: 'assets/lock.png',
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
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      if (checkValidation()) {
                        final authService = Provider.of<AuthServiceAdmin>(context, listen: false);
                        authService.signup(_emailController.text, _passController.text,
                            _phoneNumberController.text, _userNameController.text, context);
                      } else {
                        checkValidation();
                      }
                    },
                    borderRadius: BorderRadius.circular(30.0),
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
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade200,
                          height: 1.5,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Or login using',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade200,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIcon(icon: 'assets/Mask Group 1.svg'),
                      SizedBox(width: 20.0),
                      SocialIcon(icon: 'assets/Mask Group 3.svg'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
