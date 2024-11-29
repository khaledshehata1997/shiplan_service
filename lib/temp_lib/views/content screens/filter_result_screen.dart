import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/product_details_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class FilterResultScreen extends StatelessWidget {
  const FilterResultScreen(
      {super.key,
      this.category,
      this.brand,
      required this.min,
      required this.max});
  final String? category;
  final String? brand;
  final double min;
  final double max;

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
      body: Consumer<ProductController>(
        builder: (context, productProvider, _) {
          productProvider.fetchProducts();
          var products = productProvider.products;
          List<Product> filteredProducts = [];
          if (category != null && brand != null) {
            filteredProducts = products
                .where(
                  (e) =>
                      e.categoryId == category &&
                      e.brandId == brand &&
                      e.price >= min &&
                      e.price <= max,
                )
                .toList();
          } else if (category != null && brand == null) {
            filteredProducts = products
                .where(
                  (e) =>
                      e.categoryId == category &&
                      e.price >= min &&
                      e.price <= max,
                )
                .toList();
          } else if (category == null && brand != null) {
            filteredProducts = products
                .where(
                  (e) => e.brandId == brand && e.price >= min && e.price <= max,
                )
                .toList();
          } else {
            filteredProducts = products
                .where(
                  (e) => e.price >= min && e.price <= max,
                )
                .toList();
          }
          if (productProvider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (filteredProducts.isEmpty) {
            return Center(
              child: Text(S.of(context).thereisnobrandforthissearch),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
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
              ),
            );
          }
        },
      ),
    );
  }
}
