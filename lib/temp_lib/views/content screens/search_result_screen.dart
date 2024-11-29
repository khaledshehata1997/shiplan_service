import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/brand_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/product_details_screen.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/brands_content_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/brands_widget.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen(
      {super.key, required this.searchPrompt, required this.isBrandSearched});
  final String searchPrompt;
  final bool isBrandSearched;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final langController = Provider.of<LangController>(context, listen: false);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        title: Text(S.of(context).result,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: isBrandSearched
          ? Consumer<BrandController>(
              builder: (context, brandProvider, _) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: brandProvider.fetchBrands(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var brands = snapshot.data;
                      var filteredBrands = brands!
                          .where(
                            (element) => element['name']
                                .toLowerCase()
                                .contains(searchPrompt.toLowerCase()),
                          )
                          .toList();
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: List.generate(filteredBrands.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => BrandsContentScreen(
                                    title: langController.isArabic
                                        ? filteredBrands[index]['nameAr']
                                        : filteredBrands[index]['name'],
                                    brandId: filteredBrands[index]['id'],
                                  ),
                                ),
                              );
                            },
                            child: BrandsWidget(
                              name: langController.isArabic
                                  ? filteredBrands[index]['nameAr']
                                  : filteredBrands[index]['name'],
                              image: filteredBrands[index]['image'],
                              isviewAll: true,
                            ),
                          );
                        }),
                      );
                    } else {
                      return Center(
                        child: Text(S.of(context).thereisnobrandforthissearch),
                      );
                    }
                  },
                );
              },
            )
          : Consumer<ProductController>(
              builder: (context, productProvider, _) {
                productProvider.fetchProducts();
                var products = productProvider.products;
                var filteredProducts = products
                    .where(
                      (element) => element.name
                          .toLowerCase()
                          .contains(searchPrompt.toLowerCase()),
                    )
                    .toList();
                if (productProvider.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (filteredProducts.isEmpty) {
                  return Center(
                    child: Text(S.of(context).thereisnobrandforthissearch),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
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
                                name: langController.isArabic
                                    ? filteredProducts[index].nameAr
                                    : filteredProducts[index].name,
                                image: filteredProducts[index].image,
                                price: filteredProducts[index].price,
                                product: filteredProducts[index],
                              )),
                        );
                      }),
                    ),
                  );
                }
              },
            ),
    );
  }
}
