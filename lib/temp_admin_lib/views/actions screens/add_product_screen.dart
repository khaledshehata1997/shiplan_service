// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
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

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _productName = TextEditingController();
  final _productNameAr = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _arabicDescription = TextEditingController();
  final _stock = TextEditingController();
  List<Option> options = [];
  String? _selectedCategory;
  String? _selectedCategoryId;
  String? _selectedBrandId;
  List<String> _categories = [];
  List<String> _categoriesId = [];
  String? _selectedBrand;
  List<String> _brands = [];
  List<String> _brandsId = [];
  final TextEditingController quantityController = TextEditingController();
  File? optionImage;
  String optionImageUrl = '';
  bool withOptions = false;
  bool isProductAdded = false;

  void addOptionColor() {
    int? quantity = int.tryParse(quantityController.text);

    if (pickedColor != null && quantity != null) {
      setState(() {
        options.add(Option(
            color: pickedColor!.value, quantity: quantity, image: optionImageUrl, productId: ''));
      });
    } else {}
  }

  File? image;
  String imageUrl = '';
  bool isLoading = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(isProductAdded);
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('product with options:'),
                        Switch(
                            value: withOptions,
                            activeColor: defaultColor,
                            onChanged: (_) {
                              setState(() {
                                withOptions = !withOptions;
                              });
                            }),
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
                        controller: _arabicDescription,
                        decoration: inputDecoration('enter description')),
                    const SizedBox(
                      height: 10,
                    ),
                    !withOptions
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
                          _categories = snapshot.data!
                              .map(
                                (e) => e['nameEn'].toString(),
                              )
                              .toList();
                          _categoriesId = snapshot.data!
                              .map(
                                (e) => e['id'].toString(),
                              )
                              .toList();
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
                              decoration: inputDecoration('Category'));
                        } else {
                          return const Text('there is no categories please add some');
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
                          _brands = snapshot.data!
                              .map(
                                (e) => e['name'].toString(),
                              )
                              .toList();
                          _brandsId = snapshot.data!
                              .map(
                                (e) => e['id'].toString(),
                              )
                              .toList();
                          return DropdownButtonFormField<String>(
                              value: _selectedBrand,
                              hint: const Text('Select a Brand'),
                              items: _brands.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
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
                              decoration: inputDecoration('Brand'));
                        } else {
                          return const Text('there is no Brands please add some');
                        }
                      },
                    ),
                    withOptions
                        ? Column(
                            children: [
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
                                              options.removeAt(index);
                                            },
                                            child: const Icon(Icons.delete_outline),
                                          ),
                                          Text('Option ${index + 1}:'),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            'QTY:${options[index].quantity} ',
                                            style: const TextStyle(fontSize: 17),
                                          ),
                                          CircleAvatar(
                                            backgroundColor: pickedColors[index],
                                            radius: 20,
                                          ),
                                        ],
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: Image.memory(base64Decode(options[index].image)),
                                        ),
                                      )
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
                            ],
                          )
                        : const SizedBox(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('Choose image')],
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
                              if (options.isEmpty) {
                                image = optionImage;
                              }
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
                      onPressed: () async {
                        if (pickedColor == null || quantityController.text.trim().isEmpty) {
                          showTopSnackBar(
                            context,
                            "option required",
                            Icons.warning,
                            defaultColor,
                            const Duration(seconds: 4),
                          );
                        } else {
                          setState(() {
                            isOptionLoading = true;
                          });
                          setState(() {
                            optionImageUrl = Provider.of<AdImageController>(context, listen: false)
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
                      },
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
                        if (_productName.text.trim().isEmpty ||
                            _price.text.trim().isEmpty ||
                            _description.text.trim().isEmpty ||
                            _selectedCategory == null ||
                            _selectedBrand == null ||
                            _productNameAr.text.trim().isEmpty ||
                            _arabicDescription.text.trim().isEmpty) {
                          showTopSnackBar(
                            context,
                            "All fields required",
                            Icons.warning,
                            defaultColor,
                            const Duration(seconds: 4),
                          );
                        } else if (double.tryParse(_price.text) == null ||
                            double.parse(_price.text) < 1000) {
                          showTopSnackBar(
                            context,
                            "Cannot add product with price less than 1000",
                            Icons.warning,
                            Colors.red,
                            const Duration(seconds: 4),
                          );
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          setState(() {
                            imageUrl = Provider.of<AdImageController>(context, listen: false)
                                .getBase64Image!;
                          });

                          int sum = 0;
                          for (var e in options) {
                            sum += e.quantity;
                          }

                          Provider.of<AddProductController>(context, listen: false).addProduct(
                            nameAr: _productNameAr.text,
                            name: _productName.text,
                            description: _description.text,
                            arDescription: _arabicDescription.text,
                            price: double.parse(_price.text),
                            stock: _stock.text.trim().isNotEmpty ? int.parse(_stock.text) : sum,
                            imageUrl: imageUrl,
                            categoryId: _selectedCategoryId!,
                            brandId: _selectedBrandId!,
                            colors: options.map((e) => e.color).toList(),
                            colorsQuantity: options.map((e) => e.quantity).toList(),
                            optionsImages: options.map((e) => e.image).toList(),
                          );

                          setState(() {
                            isLoading = false;
                          });

                          showTopSnackBar(
                            context,
                            "Product added",
                            Icons.check_circle,
                            defaultColor,
                            const Duration(seconds: 4),
                          );

                          setState(() {
                            isProductAdded = true;
                            image = null;
                            _productName.clear();
                            _productNameAr.clear();
                            _price.clear();
                            _description.clear();
                            _arabicDescription.clear();
                            _stock.clear();
                            options = [];
                            _selectedCategory = null;
                            _selectedBrand = null;
                            _selectedCategoryId = null;
                            _selectedBrandId = null;
                          });
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Add product'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stock.dispose();
    _productName.dispose();
    _productNameAr.dispose();
    _arabicDescription.dispose();
    _description.dispose();
    _price.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
