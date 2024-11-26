import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiplan_service/view/home_view/addresess_view.dart';
import 'package:shiplan_service/view/home_view/home_view.dart';
import 'package:shiplan_service/view/home_view/mids_list_view.dart';
import 'package:shiplan_service/view/prayer_app/azkar/azkar_view.dart';
import 'package:shiplan_service/view/prayer_app/qiblah/qiblah_maps.dart';
import 'package:shiplan_service/view/prayer_app/roqua_view.dart';
import 'package:shiplan_service/view/prayer_app/sibha/sibha_view.dart';
import 'package:shiplan_service/view/profile_view/main_profile_view.dart';
import 'package:shiplan_service/view/profile_view/profile_view.dart';

import '../../constants.dart';

class PrayerNavBarView2 extends StatefulWidget {
  PrayerNavBarView2({super.key});

  @override
  State<PrayerNavBarView2> createState() => _NavBarViewState();
}
int _selectedIndex = 0;
List<Widget> _pages = [
  SibhaView(),Azkar(),Roqua(),
];
class _NavBarViewState extends State<PrayerNavBarView2> {


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
            BottomNavigationBarItem(icon: Icon(Icons.ac_unit,size: 30,),label: 'السبحه'),
            BottomNavigationBarItem(icon: Icon(Icons.list,size: 30),label: 'الاذكار'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined,size: 30),label: 'الرقيه الشرعيه'),
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
