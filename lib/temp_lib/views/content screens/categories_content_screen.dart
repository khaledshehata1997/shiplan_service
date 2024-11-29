import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/product_details_screen.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/search_result_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class CategoriesContentScreen extends StatefulWidget {
  const CategoriesContentScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<CategoriesContentScreen> createState() =>
      _CategoriesContentScreenState();
}

class _CategoriesContentScreenState extends State<CategoriesContentScreen> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final lanfController = Provider.of<LangController>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
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
                                      isBrandSearched: false,
                                    )));
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: GestureDetector(
                              onTap: () {
                                if (searchController.text.trim().isNotEmpty) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => SearchResultScreen(
                                            searchPrompt: searchController.text,
                                            isBrandSearched: false,
                                          )));
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/search-normal.svg'),
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
                height: 40,
              ),
              Consumer<ProductController>(
                builder: (context, productProvider, _) {
                  var products = productProvider.products;
                  var filteredProducts = products
                      .where(
                        (element) => element.categoryId == widget.categoryId,
                      )
                      .toList();
                  if (productProvider.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (filteredProducts.isEmpty) {
                    return Center(
                      child: Text(S.of(context).NoProductsforthisCategory),
                    );
                  } else {
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(filteredProducts.length, (index) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          height: 270,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ProductDetailsScreen(
                                        product: filteredProducts[index])));
                              },
                              child: BestSellerWidget(
                                isLoggedIn: authService.isUserLoggedIn,
                                name: lanfController.isArabic
                                    ? filteredProducts[index].nameAr
                                    : filteredProducts[index].name,
                                image: filteredProducts[index].image,
                                price: filteredProducts[index].price,
                                product: filteredProducts[index],
                              )),
                        );
                      }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
