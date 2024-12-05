// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/auth/widgets/textfield_signup.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

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
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        title: Text(S.of(context).signup),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).createNewAccount,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  S.of(context).pleaseCreateAccount,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 133, 131, 131)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  S.of(context).userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextfieldSignup(
                  controller: _userNameController,
                  type: TextInputType.text,
                  hintText: S.of(context).enterYouruserName,
                  icon: Icons.person_outline,
                  image: 'assets/user.png',
                  inputFormatters: [],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  S.of(context).emailAddress,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextfieldSignup(
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                  hintText: S.of(context).enterYourEmail,
                  icon: Icons.email_outlined,
                  image: 'assets/sms.png',
                  inputFormatters: [],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  S.of(context).phoneNumber,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextfieldSignup(
                  controller: _phoneNumberController,
                  type: TextInputType.phone,
                  hintText: S.of(context).enterYourPhoneNumber,
                  icon: Icons.phone_outlined,
                  image: 'assets/call.png',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  S.of(context).password,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextfieldSignup(
                  obscureText: _obscureText,
                  inputFormatters: [],
                  type: TextInputType.visiblePassword,
                  controller: _passController,
                  hintText: S.of(context).enterYourPassword,
                  icon: Icons.lock_outline,
                  image: 'assets/lock.png',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
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
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: ElevatedButton(
                    onPressed: !isLoading
                        ? () async {
                            setState(() {
                              isLoading = true;
                            });

                            if (_phoneNumberController.text.length != 11) {
                              showTopSnackBar(
                                context,
                                S.of(context).phone_number_is_not_valid,
                                Icons.info,
                                defaultColor,
                                const Duration(seconds: 4),
                              );
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }
                            if (checkValidation()) {
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);
                              authService.signup(
                                  _emailController.text,
                                  _passController.text,
                                  _phoneNumberController.text,
                                  _userNameController.text,
                                  context);
                            } else {
                              checkValidation();
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // <-- Radius
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Center(
                            child: Text(
                              S.of(context).createAcc,
                              style: const TextStyle(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
