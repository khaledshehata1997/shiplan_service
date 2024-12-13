import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/home_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/menu_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final zoomDrawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuScreen: const MenuScreen(),
      mainScreen: const HomeScreen(),
      style: DrawerStyle.defaultStyle,
      showShadow: true,
      angle: 0.0,
      menuBackgroundColor: defaultColor,
      shadowLayer1Color: defaultColor,
      shadowLayer2Color: const Color.fromRGBO(255, 255, 255, 0.2),
      mainScreenScale: 0.17,
    );
  }
}
