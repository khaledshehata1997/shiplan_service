import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/controllers/category_contoller.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/categories_content_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/categories_container.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/custom_search_bar.dart';

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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchBar(searchController: searchController),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
                future: Provider.of<CategoryController>(context, listen: false)
                    .fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var categories = snapshot.data!;
                    return Column(
                      children: List.generate(
                        categories.length,
                        (index) {
                          return GestureDetector(
                            onTap: () async {
                              await Provider.of<ProductController>(context,
                                      listen: false)
                                  .fetchProducts();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => CategoriesContentScreen(
                                        categoryId: categories[index]['id'],
                                      )));
                            },
                            child: CategoriesContainer(
                              name: langController.isArabic
                                  ? categories[index]['nameAr']
                                  : categories[index]['nameEn'],
                              image: categories[index]['image'],
                            ),
                          );
                        },
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
