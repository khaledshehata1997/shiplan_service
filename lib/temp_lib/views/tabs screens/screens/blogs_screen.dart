import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/screens/blogs_list.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  @override
  Widget build(BuildContext context) {
    final langController = Provider.of<LangController>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        appBar: AppBar(
          leading: SizedBox(),
          centerTitle: true,
          title: Text(S.of(context).blogs),
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        ),
        body: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsetsDirectional.only(
                  start: 10.w, top: 10.h, bottom: 10.h),
              width: 390.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      offset: const Offset(0, 0),
                      blurRadius: 15,
                    )
                  ]),
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  iconColor: defaultColor,
                ),
                header: Text(
                  blogs[index]['title'].toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                collapsed: const SizedBox(),
                expanded: Text(
                  blogs[index]['content'].toString(),
                  style: TextStyle(
                    color: defaultColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 20.h);
          },
          itemCount: blogs.length,
        ));
  }
}
