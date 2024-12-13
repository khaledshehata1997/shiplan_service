// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_brand_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_category_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_product_controller.dart';
import 'package:shiplan_service/temp_admin_lib/models/options.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_advertisment_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen(
      {super.key,
      required this.productId,
      required this.productName,
      required this.productArName,
      required this.price,
      required this.description,
      required this.arDescription,
      required this.stock,
      required this.categoryI,
      required this.brandId,
      required this.image,
      required this.options});
  final String productId;
  final String productName;
  final String productArName;
  final double price;
  final String description;
  final String arDescription;
  final int stock;
  final String categoryI;
  final String brandId;
  final String image;
  final List<Option> options;
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _productName = TextEditingController();
  final _productNameAr = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _arDescription = TextEditingController();
  final _stock = TextEditingController();
  bool isLoading = false;
  String? _selectedCategory;
  String? _selectedCategoryId;
  String? _selectedBrandId;
  List<String> _categories = [];
  List<String> _categoriesId = [];
  String? _selectedBrand;
  List<String> _brands = [];
  List<String> _brandsId = [];
  List<Option> options = [];
  File? image;
  String imageUrl = '';

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      labelText: labelText, // Dynamic labelText
      labelStyle: TextStyle(color: Colors.grey.shade400),
    );
  }

  @override
  void initState() {
    options = widget.options;
    pickedColors = widget.options
        .map(
          (e) => Color(e.color),
        )
        .toList();
    _productName.text = widget.productName;
    _productNameAr.text = widget.productArName;
    _price.text = widget.price.toString();
    _description.text = widget.description;
    _arDescription.text = widget.arDescription;
    _stock.text = widget.stock.toString();
    _selectedCategoryId = widget.categoryI;
    _selectedBrandId = widget.brandId;
    imageUrl = widget.image;
    super.initState();
  }

  File? optionImage;
  String optionImageUrl = '';
  final TextEditingController quantityController = TextEditingController();

  void addOptionColor() {
    int? quantity = int.tryParse(quantityController.text);

    if (pickedColor != null && quantity != null) {
      setState(() {
        options.add(Option(
            color: pickedColor!.value, quantity: quantity, image: optionImageUrl, productId: ''));
      });
    } else {}
  }

  bool isOptionLoading = false;

  Color? pickedColor;
  List<Color> pickedColors = [];

  void _pickColor(BuildContext context) {
    Color selectedColor = Colors.white;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                setState(() {
                  pickedColor = selectedColor;
                  pickedColors.add(selectedColor);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<AdImageController>(
                      builder: (context, imageProvider, _) {
                        return GestureDetector(
                          onTap: () async {
                            await imageProvider.pickImage(context);
                            setState(() {
                              image = imageProvider.getImage;
                            });
                          },
                          child: Container(
                              height: 120,
                              width: 335,
                              decoration: DottedDecoration(
                                color: defaultColor,
                                shape: Shape.box,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: image == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.memory(
                                        base64Decode(imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        image!,
                                        fit: BoxFit.cover,
                                      ))),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the top
                      children: [
                        Expanded(
                          // Ensures the Column takes available width inside the Row
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Aligns the content to the left
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Name Product'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                controller: _productName,
                                decoration: inputDecoration('Enter name'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Arabic Name Product'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                controller: _productNameAr,
                                decoration: inputDecoration('Enter Arabic name'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 2,
                        ),
                        Text('Price'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(controller: _price, decoration: inputDecoration('enter price')),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 2,
                        ),
                        Text('description'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _description, decoration: inputDecoration('enter description')),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 2,
                        ),
                        Text('Arabic description'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _arDescription,
                        decoration: inputDecoration('enter description')),
                    const SizedBox(
                      height: 10,
                    ),
                    options.isEmpty
                        ? Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text('Stock'),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                  controller: _stock, decoration: inputDecoration('enter stock')),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: Provider.of<AddCategoryController>(context).fetchCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          // Extract category names and IDs
                          _categories = snapshot.data!.map((e) => e['nameEn'].toString()).toList();
                          _categoriesId = snapshot.data!.map((e) => e['id'].toString()).toList();

                          // Find the category name corresponding to the already selected ID
                          if (_selectedCategoryId != null) {
                            int selectedIndex = _categoriesId.indexOf(_selectedCategoryId!);
                            if (selectedIndex != -1) {
                              _selectedCategory = _categories[selectedIndex];
                            }
                          }

                          return DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            hint: const Text('Select a category'),
                            items: _categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                                for (int i = 0; i < _categories.length; i++) {
                                  if (_selectedCategory == _categories[i]) {
                                    _selectedCategoryId = _categoriesId[i];
                                  }
                                }
                              });
                            },
                            decoration: inputDecoration('Category'),
                          );
                        } else {
                          return const Text('There are no categories, please add some.');
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: Provider.of<AddBrandController>(context).fetchBrands(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          // Extract brand names and IDs
                          _brands = snapshot.data!.map((e) => e['name'].toString()).toList();
                          _brandsId = snapshot.data!.map((e) => e['id'].toString()).toList();

                          if (_selectedBrandId != null) {
                            int selectedIndex = _brandsId.indexOf(_selectedBrandId!);
                            if (selectedIndex != -1) {
                              _selectedBrand = _brands[selectedIndex];
                            }
                          }

                          return DropdownButtonFormField<String>(
                            value: _selectedBrand,
                            hint: const Text('Select a Brand'),
                            items: _brands.map((String brand) {
                              return DropdownMenuItem<String>(
                                value: brand,
                                child: Text(brand),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedBrand = newValue;
                                for (int i = 0; i < _brands.length; i++) {
                                  if (_selectedBrand == _brands[i]) {
                                    _selectedBrandId = _brandsId[i];
                                  }
                                }
                              });
                            },
                            decoration: inputDecoration('Brand'),
                          );
                        } else {
                          return const Text('There are no brands, please add some.');
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Set Options:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ...List.generate(
                      options.length,
                      (index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      options.removeAt(index);
                                      pickedColors.removeAt(index);
                                      imageUrl = options[0].image;
                                    });
                                  },
                                  child: const Icon(Icons.delete_outline),
                                ),
                                Text('Option ${index + 1}:'),
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        options[index].quantity--;
                                      });
                                    },
                                    child: const Icon(Icons.remove)),
                                Text(
                                  'QTY:${options[index].quantity}',
                                  style: const TextStyle(fontSize: 17),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        options[index].quantity++;
                                      });
                                    },
                                    child: const Icon(Icons.add)),
                                const SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  backgroundColor: pickedColors[index],
                                  radius: 20,
                                ),
                              ],
                            ),
                            Consumer<AdImageController>(
                              builder: (context, imageProvider, _) {
                                return GestureDetector(
                                  onTap: () async {
                                    await imageProvider.pickImage(context);
                                    options[index].image = imageProvider.getBase64Image!;
                                    log(imageProvider.getBase64Image!);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.memory(base64Decode(options[index].image)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 2,
                        ),
                        Text('Color'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        pickedColor != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: CircleAvatar(
                                  backgroundColor: pickedColor,
                                  radius: 20,
                                ),
                              )
                            : const SizedBox(),
                        GestureDetector(
                          onTap: () => _pickColor(context),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 20,
                            child: const Icon(Icons.add, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 2,
                        ),
                        Text('Quantity'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: quantityController,
                      decoration: inputDecoration('Enter Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('Choose Option image')],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<AdImageController>(
                      builder: (context, imageProvider, _) {
                        return GestureDetector(
                          onTap: () async {
                            await imageProvider.pickImage(context);
                            setState(() {
                              optionImage = imageProvider.getImage;
                            });
                          },
                          child: Container(
                              height: 120,
                              width: 335,
                              decoration: DottedDecoration(
                                color: defaultColor,
                                shape: Shape.box,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: optionImage == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: defaultColor,
                                                  borderRadius: BorderRadius.circular(10)),
                                              child: SvgPicture.asset('assets/upload 01.svg')),
                                          const Text('Choose file to Upload'),
                                          Text(
                                            'supported format png, jepg',
                                            style: TextStyle(color: Colors.grey.shade400),
                                          )
                                        ],
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        optionImage!,
                                        fit: BoxFit.cover,
                                      ))),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: !isOptionLoading
                          ? () async {
                              if (pickedColor == null || quantityController.text.trim().isEmpty) {
                                showCustomNotification(context, 'option required');
                              } else {
                                setState(() {
                                  isOptionLoading = true;
                                });

                                setState(() {
                                  optionImageUrl =
                                      Provider.of<AdImageController>(context, listen: false)
                                          .getBase64Image!;
                                });
                                addOptionColor();
                                pickedColor = null;
                                quantityController.clear();
                                optionImage = null;
                                setState(() {
                                  isOptionLoading = false;
                                });
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: defaultColor, foregroundColor: Colors.white),
                      child: isOptionLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Add Color Option'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: !isLoading
                    ? () async {
                        if (_price.text.isNotEmpty && double.parse(_price.text) < 1000) {
                          showTopSnackBar(
                            context,
                            "Cannot update product with price less than 1000",
                            Icons.warning,
                            Colors.red,
                            const Duration(seconds: 4),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });
                        if (image != null) {
                          setState(() {
                            imageUrl = Provider.of<AdImageController>(context, listen: false)
                                .getBase64Image!;
                          });
                        }

                        int sum = 0;
                        for (var e in options) {
                          sum += e.quantity;
                        }

                        log('${options.map((e) => e.color)}');

                        Provider.of<AddProductController>(context, listen: false).updateProduct(
                          productId: widget.productId,
                          name: _productName.text.isNotEmpty ? _productName.text : null,
                          nameAr: _productNameAr.text.isNotEmpty ? _productNameAr.text : null,
                          price: _price.text.isNotEmpty ? double.parse(_price.text) : null,
                          stock: options.isEmpty ? int.parse(_stock.text) : sum,
                          description: _description.text.isNotEmpty ? _description.text : null,
                          arDescription:
                              _arDescription.text.isNotEmpty ? _arDescription.text : null,
                          categoryId: _selectedCategory != null ? _selectedCategoryId : null,
                          brandId: _selectedBrand != null ? _selectedBrandId : null,
                          imageUrl: imageUrl,
                          colors: options.map((e) => e.color).toList(),
                          colorsQuantity: options.map((e) => e.quantity).toList(),
                          optionsImages: options.map((e) => e.image).toList(),
                        );

                        showTopSnackBar(
                          context,
                          "Product Updated",
                          Icons.check_circle,
                          Colors.red,
                          const Duration(seconds: 4),
                        );

                        setState(() {
                          isLoading = false;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100.0,
        left: MediaQuery.of(context).size.width * 0.30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
