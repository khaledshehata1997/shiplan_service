// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/auth_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/push_notification_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/auth/screens/login_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/advertisments_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/all_coupons_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/brands_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/categories_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/oreders_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/products_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/settings_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServiceAdmin>(context, listen: false);
    return Scaffold(
        backgroundColor: defaultColor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/Miss Cady.svg',
                          width: 140,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ListTile(
                      onTap: () {
                        ZoomDrawer.of(context)!.close();
                      },
                      leading: SvgPicture.asset('assets/Component 2.svg'),
                      title: const Text(
                        'Dashboard',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (authService.isUserLoggedIn) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) => const CategoriesScreen()));
                        } else {
                          authService.showLoginDialog(context);
                        }
                      },
                      leading: SvgPicture.asset('assets/profile.svg'),
                      title: const Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (authService.isUserLoggedIn) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProductsScreen(),
                          ));
                        } else {
                          authService.showLoginDialog(context);
                        }
                      },
                      leading: SvgPicture.asset('assets/Component 2 (1).svg'),
                      title: const Text(
                        'Products',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (authService.isUserLoggedIn) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) => const BrandsScreen()));
                        } else {
                          authService.showLoginDialog(context);
                        }
                      },
                      leading: SvgPicture.asset('assets/Component 2 (2).svg'),
                      title: const Text(
                        'Brands',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (authService.isUserLoggedIn) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => const AdvertismentsScreen()));
                        } else {
                          authService.showLoginDialog(context);
                        }
                      },
                      leading: SvgPicture.asset('assets/Component 2 (3).svg'),
                      title: const Text(
                        'Advertisments',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (authService.isUserLoggedIn) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) => const OredersScreen()));
                        } else {
                          authService.showLoginDialog(context);
                        }
                      },
                      leading: const Icon(
                        Icons.delivery_dining_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Orders',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (authService.isUserLoggedIn) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) => const AllCouponsScreen()));
                        } else {
                          authService.showLoginDialog(context);
                        }
                      },
                      leading: Image.asset(
                        'assets/coupon.png',
                        color: Colors.white,
                        width: 25,
                      ),
                      title: const Text(
                        'Coupons',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (authService.isUserLoggedIn) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => const PushNotificationScreen()));
                        } else {
                          authService.showLoginDialog(context);
                        }
                      },
                      leading: const Icon(
                        Icons.notification_add_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        if (authService.isUserLoggedIn) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
                        } else {
                          authService.showLoginDialog(context);
                        }
                      },
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (authService.isUserLoggedIn) {
                    authService.logout();
                    if (ZoomDrawer.of(context)!.isOpen()) {
                      ZoomDrawer.of(context)!.close();
                    }
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => const LoginScreen()));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    const Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      authService.isUserLoggedIn ? 'Logout' : 'Login',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ));
  }
}
