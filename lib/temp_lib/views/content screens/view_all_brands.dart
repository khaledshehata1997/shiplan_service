import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/brand_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/brands_content_screen.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/search_result_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/brands_widget.dart';

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
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          controller: searchController,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => SearchResultScreen(
                                        searchPrompt: value,
                                        isBrandSearched: true,
                                      )));
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  if (searchController.text.trim().isNotEmpty) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                SearchResultScreen(
                                                  searchPrompt:
                                                      searchController.text,
                                                  isBrandSearched: true,
                                                )));
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/search-normal.svg'),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                              hintText: S.of(context).search,
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.4))),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
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
                        return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: List.generate(brands.length, (index) {
                            return GestureDetector(
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
                              child: BrandsWidget(
                                name: langController.isArabic
                                    ? brands[index]['nameAr']
                                    : brands[index]['name'],
                                image: brands[index]['image'],
                                isviewAll: true,
                              ),
                            );
                          }),
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
