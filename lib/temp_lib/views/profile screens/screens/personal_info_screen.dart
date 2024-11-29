// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('tempUsers')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone_number'] ?? '';
        });
      }
    }
  }

  Future<void> _updateEmail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateEmail(_emailController.text);
        await FirebaseFirestore.instance
            .collection('tempUsers')
            .doc(user.uid)
            .update({'email': _emailController.text});
        showTopSnackBar(
          context,
          S.of(context).email_updated_successfully,
          Icons.info,
          defaultColor,
          const Duration(seconds: 4),
        );
      }
    } catch (e) {
      showTopSnackBar(
        context,
        '${S.of(context).failed_to_update_email}: $e',
        Icons.info,
        defaultColor,
        const Duration(seconds: 4),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(_passwordController.text);
        showTopSnackBar(
          context,
          S.of(context).password_updated_successfully,
          Icons.info,
          defaultColor,
          const Duration(seconds: 4),
        );
      }
    } catch (e) {
      showTopSnackBar(
        context,
        '${S.of(context).failed_to_update_password}: $e',
        Icons.info,
        defaultColor,
        const Duration(seconds: 4),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePhoneNumber() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_phoneController.text.length != 11) {
        showTopSnackBar(
          context,
          S.of(context).phone_number_is_not_valid,
          Icons.info,
          defaultColor,
          const Duration(seconds: 4),
        );
        return;
      }
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('tempUsers')
            .doc(user.uid)
            .update({'phone_number': _phoneController.text});
        showTopSnackBar(
          context,
          S.of(context).phone_number_updated_successfully,
          Icons.info,
          defaultColor,
          const Duration(seconds: 4),
        );
      }
    } catch (e) {
      showTopSnackBar(
        context,
        '${S.of(context).failed_to_update_phone_number}: $e',
        Icons.info,
        defaultColor,
        const Duration(seconds: 4),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        title: Text(S.of(context).profile,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(S.of(context).emailAddress, _emailController,
                _updateEmail, true),
            _buildTextField(S.of(context).phoneNumber, _phoneController,
                _updatePhoneNumber, false),
            _buildPasswordField(
                S.of(context).password, _passwordController, _updatePassword),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      VoidCallback onUpdate, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            cursorColor: Colors.black,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.phone,
            inputFormatters:
                isEmail ? [] : [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
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
              labelText: label,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: defaultColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('${S.of(context).update} $label'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, VoidCallback onUpdate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: true,
            cursorColor: Colors.black,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
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
              labelText: label,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: defaultColor, // Background color
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
            child: Text('${S.of(context).update} $label'),
          ),
        ],
      ),
    );
  }
}
