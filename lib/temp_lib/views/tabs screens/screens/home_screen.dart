import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/brand_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/category_contoller.dart';
import 'package:shiplan_service/temp_lib/controllers/discounts_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/product_details_screen.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/brands_content_screen.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/categories_content_screen.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/view_all_brands.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/view_all_product_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/beauty_services_widget.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/brands_widget.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/custom_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final langController = Provider.of<LangController>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(searchController: searchController),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Text(
                S.of(context).categories,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: Provider.of<CategoryController>(context, listen: false)
                .fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                var categories = snapshot.data;
                return SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories!.length,
                    itemBuilder: (context, index) {
                      var category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => CategoriesContentScreen(
                                    categoryId: categories[index]['id'],
                                  )));
                        },
                        child: BeautyServicesWidget(
                          image: category['image'],
                          name: langController.isArabic
                              ? category['nameAr']
                              : category['nameEn'],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Text(S.of(context).NobeautyServiceavailable);
              }
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 12.w,
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future:
                      Provider.of<DiscountsController>(context, listen: false)
                          .fetchDiscounts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      var discounts = snapshot.data!;
                      return CarouselSlider.builder(
                        itemCount: discounts.length,
                        itemBuilder: (context, index, realIndex) {
                          var discount = discounts[index];
                          return Container(
                            padding: const EdgeInsets.all(10),
                            height: 140.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: MemoryImage(
                                    base64Decode(discount['image'])),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 160.h,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          enlargeCenterPage: false,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    S.of(context).topBrand,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const ViewAllBrands()));
                  },
                  child: Text(
                    S.of(context).viewAll,
                    style: TextStyle(
                        color: defaultColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ))
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
              future: Provider.of<BrandController>(context, listen: false)
                  .fetchBrands(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(S.of(context).Something_went_wrong));
                } else if (snapshot.hasData) {
                  var brands = snapshot.data!;
                  return SizedBox(
                    height: 255.h,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // mainAxisSpacing: 5,
                              crossAxisSpacing: 20,
                              childAspectRatio: 1),
                      scrollDirection: Axis.horizontal,
                      itemCount: brands.length,
                      itemBuilder: (context, index) {
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
                            isviewAll: false,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text(S.of(context).nobrandsfound));
                }
              }),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    S.of(context).bestSellerProducts,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ViewAllProductScreen(
                              isLoggedIn: widget.isLoggedIn,
                            )));
                  },
                  child: Text(
                    S.of(context).viewAll,
                    style: const TextStyle(
                        color: defaultColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ))
            ],
          ),
          Consumer<ProductController>(
            builder: (context, productProvider, _) {
              productProvider.fetchProducts();
              if (productProvider.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var bestsellerProducts = productProvider.bestsellerProducts;
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: List.generate(bestsellerProducts.length, (index) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 48.w) / 2,
                      height: 270.h,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ProductDetailsScreen(
                                      product: bestsellerProducts[index],
                                    )));
                          },
                          child: BestSellerWidget(
                            isLoggedIn: widget.isLoggedIn,
                            name: langController.isArabic
                                ? bestsellerProducts[index].nameAr
                                : bestsellerProducts[index].name,
                            image: bestsellerProducts[index].image,
                            price: bestsellerProducts[index].price,
                            product: bestsellerProducts[index],
                          )),
                    );
                  }),
                );
              }
            },
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    S.of(context).allProducts,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
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
                      width: (MediaQuery.of(context).size.width - 48.w) / 2,
                      height: 270.h,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ProductDetailsScreen(
                                      product: products[index],
                                    )));
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
          SizedBox(
            height: 40.h,
          ),
        ],
      ),
    );
  }
}
