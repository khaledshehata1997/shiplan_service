import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiplan_service/view/home_view/addresess_view.dart';
import 'package:shiplan_service/view/home_view/home_view.dart';
import 'package:shiplan_service/view/profile_view/main_profile_view.dart';
import 'package:shiplan_service/view/profile_view/profile_view.dart';

import '../../constants.dart';
import 'Favorite_view.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({super.key});

  @override
  State<NavBarView> createState() => _NavBarViewState();
}
int _selectedIndex = 0;
const List<Widget> _pages = [
  HomeView(),AddresessView(),MainProfileView(),
];
class _NavBarViewState extends State<NavBarView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.black,
          type : BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined,size: 30,),label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_outline,size: 30),label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined,size: 30),label: ''),
          ],

        ),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
