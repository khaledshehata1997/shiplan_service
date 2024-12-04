import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/product_details_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class ViewAllProductScreen extends StatefulWidget {
  const ViewAllProductScreen({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  State<ViewAllProductScreen> createState() => _ViewAllProductScreenState();
}

class _ViewAllProductScreenState extends State<ViewAllProductScreen> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final langController = Provider.of<LangController>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        appBar: AppBar(
          title: Text(S.of(context).bestSellerProducts),
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<ProductController>(
                  builder: (context, productProvider, _) {
                    productProvider.fetchProducts();
                    if (productProvider.products.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      var products = productProvider.products;
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: List.generate(products.length, (index) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 48) / 2,
                            height: 270,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => ProductDetailsScreen(
                                          product: products[index])));
                                },
                                child: BestSellerWidget(
                                  isLoggedIn: widget.isLoggedIn,
                                  name: langController.isArabic
                                      ? products[index].nameAr
                                      : products[index].name,
                                  image: products[index].image,
                                  price: products[index].price,
                                  product: products[index],
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
      ),
    );
  }
}
