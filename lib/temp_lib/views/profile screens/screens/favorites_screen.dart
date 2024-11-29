import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/favorites_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/product_details_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a 2-second delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final langController = Provider.of<LangController>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        appBar: AppBar(
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          title: Text(S.of(context).favorites,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Consumer<FavoritesController>(
          builder: (context, favController, _) {
            final authService =
                Provider.of<AuthService>(context, listen: false);
            if (authService.isUserLoggedIn) {
              favController.getFavorites(authService.user!.uid);
            }
            if (isLoading) {
              // Show loading indicator for 2 seconds
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (favController.favorites.isEmpty) {
              // Show "No Favorites Yet" message if no data
              return Center(
                child: Text(
                  S.of(context).noFavYet,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            } else {
              // Display the favorites list
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children:
                      List.generate(favController.favorites.length, (index) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 48) / 2,
                      height: 270,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ProductDetailsScreen(
                                product: favController.favorites[index],
                                isFavScreen: true,
                              ),
                            ),
                          );
                        },
                        child: BestSellerWidget(
                          isLoggedIn:
                              Provider.of<AuthService>(context, listen: false)
                                  .isUserLoggedIn,
                          name: langController.isArabic
                              ? favController.favorites[index].nameAr
                              : favController.favorites[index].name,
                          image: favController.favorites[index].image,
                          price: favController.favorites[index].price,
                          product: favController.favorites[index],
                        ),
                      ),
                    );
                  }),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
