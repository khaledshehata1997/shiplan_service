import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/brand_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/brands_content_screen.dart';

class ViewAllBrands extends StatefulWidget {
  const ViewAllBrands({super.key});

  @override
  State<ViewAllBrands> createState() => _ViewAllBrandsState();
}

class _ViewAllBrandsState extends State<ViewAllBrands> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final langController = Provider.of<LangController>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          appBar: AppBar(
            title: Text(S.of(context).topBrand),
            backgroundColor:
                themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              children: [
                FutureBuilder<List<Map<String, dynamic>>>(
                    future: Provider.of<BrandController>(context, listen: false)
                        .fetchBrands(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        var brands = snapshot.data!;
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
                            brands.length,
                            (index) => InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => BrandsContentScreen(
                                      title: langController.isArabic
                                          ? brands[index]['nameAr']
                                          : brands[index]['name'],
                                      brandId: brands[index]['id'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: defaultColor),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.10),
                                              offset: const Offset(0, -3),
                                              blurRadius: 10,
                                            ),
                                          ],
                                          image: DecorationImage(
                                              image: MemoryImage(base64Decode(
                                                  brands[index]['image'])),
                                              fit: BoxFit.fill)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    langController.isArabic
                                        ? brands[index]['nameAr']
                                        : brands[index]['name'],
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
                        return const Center(child: Text('No Brands found.'));
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
