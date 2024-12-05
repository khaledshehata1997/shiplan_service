// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/auth/screens/login_screen.dart';
import 'package:shiplan_service/temp_lib/views/profile%20screens/screens/favorites_screen.dart';
import 'package:shiplan_service/temp_lib/views/profile%20screens/screens/lang_screen.dart';
import 'package:shiplan_service/temp_lib/views/profile%20screens/screens/orders_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/tabs_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? imageUrl;

  Future<String> fetchSupportNumber() async {
    try {
      // Access the 'supportNumbers' collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('supportNumbers')
          .limit(1) // Limiting to 1 document (or adjust based on your needs)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming you want to fetch the first document from the collection
        DocumentSnapshot doc = snapshot.docs.first;
        // Retrieve the 'number' field from the document
        return doc['number'] ??
            ''; // Return the number field or empty string if not available
      } else {
        return ''; // Return empty string if no document found
      }
    } catch (e) {
      // Handle any errors, such as network issues
      print("Error fetching support number: $e");
      return ''; // Return empty string if an error occurs
    }
  }

  Future<void> launchWhatsApp(String phoneNumber) async {
    final formattedPhoneNumber = '$phoneNumber';

    final whatsappUrl = 'whatsapp://send?phone=$formattedPhoneNumber';
    final apiUrl = 'https://api.whatsapp.com/send?phone=$formattedPhoneNumber';
    log(whatsappUrl);

    try {
      final canLaunchWhatsApp = await launchUrl(Uri.parse(whatsappUrl));
      if (canLaunchWhatsApp) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        final canLaunchApi = await launchUrl(Uri.parse(apiUrl));
        ;
        if (canLaunchApi) {
          await launchUrl(Uri.parse(apiUrl));
        } else {
          showTopSnackBar(context, 'No support available now',
              Icons.error_outline, defaultColor, const Duration(seconds: 4));
        }
      }
    } catch (e) {
      print("Error launching WhatsApp: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      appBar: AppBar(
        leading: SizedBox(),
        centerTitle: true,
        title: Text(S.of(context).profile),
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: SvgPicture.asset('assets/card.svg',
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  title: Text(S.of(context).yourOrders),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const OrdersScreen()),
                    );
                  },
                ),
                Divider(color: Colors.grey.shade200),
                ListTile(
                  leading: SvgPicture.asset('assets/global.svg',
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  title: Text(S.of(context).language),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const LangScreen()),
                    );
                  },
                ),
                Divider(color: Colors.grey.shade200),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: Text(S.of(context).favorites),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => const FavoritesScreen()),
                    );
                  },
                ),
                Divider(color: Colors.grey.shade200),
                SwitchListTile(
                  title: Row(
                    children: [
                      const Icon(Icons.visibility_outlined),
                      const SizedBox(width: 10),
                      Text(S.of(context).darkMode),
                    ],
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      themeProvider.toggleTheme();
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
                Divider(color: Colors.grey.shade200),
                // Add the Delete Account option here
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(S.of(context).deleteAccount),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              // Call the deleteAccount function
                              Provider.of<AuthService>(context, listen: false)
                                  .deleteAccount(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              if (authService.isUserLoggedIn) {
                authService.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (ctx) => const TabsScreen(isLoggedIn: false)),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 60.0,
              decoration: BoxDecoration(
                color: defaultColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  authService.isUserLoggedIn
                      ? S.of(context).logout
                      : S.of(context).login,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
