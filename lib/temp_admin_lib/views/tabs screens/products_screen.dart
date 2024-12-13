import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_product_controller.dart';
import 'package:shiplan_service/temp_admin_lib/models/options.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_product_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/edit_product_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<GlobalKey> _dotKeys = [];

  @override
  void initState() {
    super.initState();
    _dotKeys = List.generate(100, (index) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(17, 8, 8, 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Add Product and refresh the product list.
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const AddProductScreen(),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      backgroundColor: defaultColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 10),
                        Text('Add New Product'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: Provider.of<AddProductController>(context, listen: false).fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var products = snapshot.data!;

                    // Ensure there are enough keys for all products.
                    if (_dotKeys.length < products.length) {
                      _dotKeys = List.generate(products.length, (index) => GlobalKey());
                    }

                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(products.length, (index) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          height: 270,
                          child: Stack(
                            children: [
                              BestSellerWidget(
                                isLoggedIn: true,
                                name: products[index]['name'],
                                image: products[index]['image'],
                                price: products[index]['price'].toDouble(),
                              ),
                              Positioned(
                                right: 15,
                                top: 15,
                                child: GestureDetector(
                                  key: _dotKeys[index],
                                  onTap: () async {
                                    final RenderBox renderBox = _dotKeys[index]
                                        .currentContext!
                                        .findRenderObject() as RenderBox;
                                    final Offset position = renderBox.localToGlobal(Offset.zero);
                                    showMenu(
                                      context: context,
                                      color: Colors.white,
                                      position: RelativeRect.fromLTRB(
                                        position.dx,
                                        position.dy,
                                        MediaQuery.of(context).size.width - position.dx,
                                        MediaQuery.of(context).size.height - position.dy,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      items: [
                                        PopupMenuItem(
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                List<Option> options = [];
                                                final colors = products[index]['colors'];
                                                for (int i = 0; i < colors.length; i++) {
                                                  Option option = Option(
                                                    color: products[index]['colors'][i],
                                                    image: products[index]['optionImages'][i],
                                                    quantity: products[index]['colorsQuantity'][i],
                                                    productId: '',
                                                  );
                                                  setState(() {
                                                    options.add(option);
                                                  });
                                                }

                                                Navigator.of(context).pop();
                                                Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) => EditProductScreen(
                                                      productId: products[index]['id'],
                                                      productName: products[index]['name'],
                                                      productArName: products[index]['nameAr'],
                                                      price: products[index]['price'],
                                                      description: products[index]['description'],
                                                      arDescription: products[index]
                                                          ['arDescription'],
                                                      stock: products[index]['stock'],
                                                      categoryI: products[index]['categoryId'],
                                                      brandId: products[index]['brandId'],
                                                      image: products[index]['image'],
                                                      options: options,
                                                    ),
                                                  ),
                                                )
                                                    .then((_) async {
                                                  await Future.delayed(const Duration(seconds: 1));

                                                  setState(() {});
                                                });
                                              },
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset('assets/Pencil.svg'),
                                                    const SizedBox(width: 10),
                                                    const Text('Edit'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.info,
                                                          color: defaultColor,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        const Text('Delete Product'),
                                                        const Spacer(),
                                                        IconButton(
                                                          icon: const Icon(Icons.close),
                                                          onPressed: () =>
                                                              Navigator.of(context).pop(),
                                                        ),
                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'Are you sure you want to delete this Product?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Cancel',
                                                            style: TextStyle(color: Colors.grey)),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: defaultColor,
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(context).pop();
                                                          await Provider.of<AddProductController>(
                                                                  context,
                                                                  listen: false)
                                                              .deleteProduct(products[index]['id']);
                                                          setState(() {
                                                            products.removeAt(index);
                                                          });
                                                        },
                                                        child: const Text('Delete'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset('assets/Trash.svg'),
                                                const SizedBox(width: 10),
                                                const Text('Delete'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  child: SvgPicture.asset('assets/dots.svg'),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  } else {
                    return const Center(child: Text('No products found.'));
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
