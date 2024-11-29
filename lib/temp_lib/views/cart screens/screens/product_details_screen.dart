// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/cart_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/favorites_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/models/favorties.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/cart_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key, required this.product, this.hasOption, this.isFavScreen});
  final Product product;
  final bool? hasOption;
  final bool? isFavScreen;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isLoading = false;
  int _counter = 1;
  bool? isFav = false;
  double pickedPrice = 0;
  String imageurl = '';
  int selectedIndex = 0;
  Product? product;
  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();
  List<String> imagesUrls = [];
  late List<MemoryImage> decodedImages;
  @override
  void initState() {
    super.initState();
    final images = widget.product.optionImages!
        .map(
          (e) => e,
        )
        .toList();
    imagesUrls = images.isNotEmpty ? [...images] : [widget.product.image];
    decodedImages = imagesUrls
        .map((base64String) => MemoryImage(base64Decode(base64String)))
        .toList();
    imageurl = widget.product.image;
    pickedPrice = widget.product.price;
    product = widget.product;
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      DocumentReference userFavoritesDoc = FirebaseFirestore.instance
          .collection('favorites')
          .doc(authService.user!.uid);
      DocumentSnapshot snapshot = await userFavoritesDoc.get();
      if (snapshot.exists) {
        Favorites favorites =
            Favorites.fromMap(snapshot.data() as Map<String, dynamic>);
        setState(() {
          isFav = favorites.products
              .any((product) => product.id == widget.product.id);
        });
      } else {
        setState(() {
          isFav = false;
        });
      }
    } catch (e) {
      log("Error checking if product is favorited: $e");
      setState(() {
        isFav = false;
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      Provider.of<CartController>(context, listen: false)
          .setNewTotalPrice(product!.price * _counter, true);
      Provider.of<ProductController>(context, listen: false)
          .updateQuantityInCart(product!, 'add');
    });
    setItemPrice();
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        Provider.of<CartController>(context, listen: false)
            .setNewTotalPrice(product!.price * _counter, false);
        Provider.of<ProductController>(context, listen: false)
            .updateQuantityInCart(product!, 'sub');
      }
    });
    setItemPrice();
  }

  void setItemPrice() {
    pickedPrice = product!.price * _counter;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final favProvider =
        Provider.of<FavoritesController>(context, listen: false);
    final langController = Provider.of<LangController>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        appBar: AppBar(
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            S.of(context).productDetails,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (authService.isUserLoggedIn) {
                  setState(() {
                    isFav = !isFav!;
                  });
                  if (isFav!) {
                    favProvider.addToFavorites(
                        authService.user!.uid, widget.product);
                  } else {
                    favProvider.removeFromFavorites(
                        authService.user!.uid, widget.product.id!);
                    if (widget.isFavScreen != null) {
                      Navigator.pop(context);
                    }
                  }
                } else {
                  showTopSnackBar(
                      context,
                      S.of(context).you_have_to_login_first,
                      Icons.check_circle,
                      defaultColor,
                      const Duration(seconds: 4));
                }
              },
              icon: Icon(isFav! ? Icons.favorite : Icons.favorite_border,
                  color: Colors.black),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CarouselSlider(
                              carouselController: _carouselSliderController,
                              options: CarouselOptions(
                                height: 304,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                              ),
                              items: decodedImages.map((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 304,
                                      width: 370,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[200],
                                        image: DecorationImage(
                                          image: imageUrl,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),

                            // Left Arrow
                            Positioned(
                              left: 10,
                              top: 140,
                              child: IconButton(
                                icon: Icon(langController.isArabic
                                    ? Icons.arrow_forward_ios
                                    : Icons.arrow_back_ios),
                                onPressed: () {
                                  _carouselSliderController.previousPage();
                                },
                              ),
                            ),

                            // Right Arrow
                            Positioned(
                              right: 10,
                              top: 140,
                              child: IconButton(
                                icon: Icon(langController.isArabic
                                    ? Icons.arrow_back_ios
                                    : Icons.arrow_forward_ios),
                                onPressed: () {
                                  _carouselSliderController.nextPage();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            langController.isArabic
                                ? widget.product.nameAr
                                : widget.product.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          // ElevatedButton(
                          //     onPressed: () {
                          //       Share.share(
                          //           'Check out this product: ${widget.product.name}\n${widget.product.image}',
                          //           subject: 'Product Recommendation');
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //         backgroundColor: Colors.white,
                          //         elevation: 0,
                          //         foregroundColor: Colors.black,
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 0,
                          //         ),
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(10),
                          //         )),
                          //     child: const Icon(Icons.share)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${pickedPrice}IQD',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _decrementCounter,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: langController.isArabic
                                        ? const BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          )
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Center(
                                  child: Text('$_counter'),
                                ),
                              ),
                              GestureDetector(
                                onTap: _incrementCounter,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: langController.isArabic
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          )
                                        : const BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          ),
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        langController.isArabic
                            ? widget.product.arDescription!
                            : widget.product.description!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      widget.product.optionImages!.isNotEmpty
                          ? Column(
                              children: [
                                Text(
                                  S.of(context).ChooseColors,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Row(
                        children: [
                          ...List.generate(
                            widget.product.colors.length,
                            (index) {
                              var color = widget.product.colors[index];
                              bool isSelected = selectedIndex ==
                                  index; // Check if this is the selected color
                              return Container(
                                margin: langController.isArabic
                                    ? const EdgeInsets.only(left: 7)
                                    : const EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                    _carouselSliderController
                                        .animateToPage(selectedIndex);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Color(color),
                                    radius: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 60.0,
              child: ElevatedButton(
                onPressed: !isLoading
                    ? () async {
                        setState(() {
                          isLoading = true;
                        });
                        // log('quantity in cart: ${product!.quantityInCart}');
                        log('counter: $_counter');
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        if (authService.isUserLoggedIn) {
                          setState(() {
                            product = Product(
                                name: product!.name,
                                arDescription: product!.arDescription,
                                nameAr: product!.nameAr,
                                price: product!.price,
                                image: product!.optionImages!.isEmpty
                                    ? product!.image
                                    : product!.optionImages![selectedIndex],
                                sold: product!.sold,
                                brandId: product!.brandId,
                                categoryId: product!.categoryId,
                                description: product!.description,
                                id: product!.id,
                                quantityInCart: product!.quantityInCart,
                                stock: product!.stock,
                                colors: product!.colors,
                                colorsQuantity: product!.colorsQuantity,
                                optionImages: product!.optionImages,
                                selectedColor: product!.optionImages!.isEmpty
                                    ? null
                                    : product!.colors[selectedIndex],
                                selectedColorIndex: selectedIndex);
                          });

                          final productProvider =
                              Provider.of<ProductController>(context,
                                  listen: false);
                          setState(() {
                            productProvider.selectedOptionIndex = selectedIndex;
                          });
                          log('${productProvider.selectedOptionIndex}');
                          final cartProvider = Provider.of<CartController>(
                              context,
                              listen: false);
                          cartProvider.addProductsToList(product!);
                          await cartProvider.addToCart(context);
                          cartProvider.fetchCart(context, true,
                              pickedPrice: pickedPrice);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const CartScreen()));
                        } else {
                          authService.showLoginDialog(context);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset('assets/shopping-cart.svg'),
                          Text(
                            S.of(context).AddToCart,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${pickedPrice}IQD',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )
                        ],
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
