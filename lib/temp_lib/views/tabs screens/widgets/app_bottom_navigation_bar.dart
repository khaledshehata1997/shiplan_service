import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.updateIndex,
  });

  final int currentIndex;
  final Function updateIndex;
  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      width: 375.w,
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(18.r),
          topEnd: Radius.circular(18.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(0, -3),
            blurRadius: 10,
          )
        ],
      ),
      child: SalomonBottomBar(
        currentIndex: widget.currentIndex,
        backgroundColor: Colors.transparent,
        onTap: (index) async {
          widget.updateIndex(index);
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              "assets/house.svg",
              width: 24,
              height: 24,
              color: widget.currentIndex == 0 ? defaultColor : Colors.black,
            ),
            title: Text(
              S.of(context).home,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Alexandria',
              ),
            ),
            selectedColor: defaultColor,
            unselectedColor: Colors.black,
          ),

          /// categories
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              "assets/categories2.svg",
              width: 24,
              height: 24,
              color: widget.currentIndex == 1 ? defaultColor : Colors.black,
            ),
            title: Text(
              S.of(context).categories,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Alexandria',
              ),
            ),
            selectedColor: defaultColor,
            unselectedColor: Colors.black,
          ),

          /// Blogs
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              "assets/blogs.svg",
              width: 24,
              height: 24,
              color: widget.currentIndex == 2 ? defaultColor : Colors.black,
            ),
            title: Text(
              S.of(context).blogs,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Alexandria',
              ),
            ),
            selectedColor: defaultColor,
            unselectedColor: Colors.black,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              "assets/profile2.svg",
              width: 24,
              height: 24,
              color: widget.currentIndex == 3 ? defaultColor : Colors.black,
            ),
            title: Text(
              S.of(context).profile,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Alexandria',
              ),
            ),
            selectedColor: defaultColor,
            unselectedColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
