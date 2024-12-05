import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/category_contoller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/categories_content_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final langController = Provider.of<LangController>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).categories),
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        leading: SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
                future: Provider.of<CategoryController>(context, listen: false)
                    .fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var categories = snapshot.data;
                    return GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      childAspectRatio: 1 / 1,
                      children: List.generate(
                        categories!.length,
                        (index) => InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => CategoriesContentScreen(
                                      categoryId: categories[index]['id'],
                                    )));
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: defaultColor),
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.10),
                                          offset: const Offset(0, -3),
                                          blurRadius: 10,
                                        ),
                                      ],
                                      image: DecorationImage(
                                          image: MemoryImage(base64Decode(
                                              categories[index]['image'])),
                                          fit: BoxFit.fill)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                langController.isArabic
                                    ? categories[index]['nameAr']
                                    : categories[index]['nameEn'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text('No categories found.'));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
