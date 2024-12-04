// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/cart_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/cart_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/screens/blogs_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/screens/categories_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/screens/home_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/screens/profile_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/app_bottom_navigation_bar.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool isLoading = false;

  void updateIndex({
    required int index,
  }) {
    _currentIndex = index;
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              HomeScreen(isLoggedIn: widget.isLoggedIn),
              const CategoriesScreen(),
              const BlogsScreen(),
              const ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: _currentIndex,
            updateIndex: (int index) => updateIndex(index: index)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    final cartProvider =
                        Provider.of<CartController>(context, listen: false);
                    if (cartProvider.cartItem != null) {
                      cartProvider.cartItem = null;
                    }
                    await cartProvider.addToCart(context);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const CartScreen()));
                  },
            shape: const CircleBorder(),
            backgroundColor: defaultColor,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : SvgPicture.asset('assets/shopping-cart.svg')),
      ),
    );
  }

  Widget _buildAnimatedTabItem(
    BuildContext context, {
    required int index,
    required String image,
    required String label,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2.0,
            width: isSelected ? 24.0 : 0.0,
            color: isSelected ? defaultColor : Colors.transparent,
          ),
          const SizedBox(height: 4.0),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: SvgPicture.asset(
              image,
              height: 20,
              width: 20,
              // ignore: deprecated_member_use
              color: isSelected
                  ? defaultColor
                  : themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isSelected ? defaultColor : Colors.black,
              fontSize: isSelected ? 16.0 : 14.0,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
