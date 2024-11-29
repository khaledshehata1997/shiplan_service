// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/brand_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/category_contoller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/filter_result_screen.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double _minPrice = 100;
  double _maxPrice = 1200;
  int _selectedBrand = 0;
  int _selectedCategory = 1;
  String? _selectedCategoryName;
  String? _selectedBrandName;
  List<String> _brands = [];
  List<String> _categories = [];
  Map<String, String> _categoryNameToId = {};
  Map<String, String> _brandNameToId = {};
  @override
  void initState() {
    initializeLists();
    super.initState();
  }

  Future<void> initializeLists() async {
    List<Map<String, dynamic>> categoriesData =
        await Provider.of<CategoryController>(context, listen: false)
            .fetchCategories();
    final langController = Provider.of<LangController>(context, listen: false);
    setState(() {
      _categories = langController.isArabic
          ? categoriesData
              .map((category) => category['nameAr'] as String)
              .toList()
          : categoriesData
              .map((category) => category['nameEn'] as String)
              .toList();
      _selectedCategoryName = _categories[0];
      _categoryNameToId = {
        for (var category in categoriesData)
          category['nameEn'] as String: category['id'] as String,
      };
    });

    List<Map<String, dynamic>> brandsData =
        await Provider.of<BrandController>(context, listen: false)
            .fetchBrands();
    setState(() {
      _brands = langController.isArabic
          ? brandsData.map((brand) => brand['nameAr'] as String).toList()
          : brandsData.map((brand) => brand['name'] as String).toList();
      _selectedBrandName = _brands[0];
      _brandNameToId = {
        for (var brand in brandsData)
          brand['name'] as String: brand['id'] as String,
      };
    });
  }

  String getCategoryId(String categoryName) {
    return _categoryNameToId[categoryName] ?? '';
  }

  String getBrandId(String brandName) {
    return _brandNameToId[brandName] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sliderWidth = screenWidth - 40;
    const double minLabelWidth = 60.0;

    double getLeftPosition(double value) {
      double position = (value / 2000) * sliderWidth;
      if (position < minLabelWidth / 2) {
        return 0;
      } else if (position > sliderWidth - minLabelWidth / 2) {
        return sliderWidth - minLabelWidth;
      } else {
        return position - minLabelWidth / 2;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).brands,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List<Widget>.generate(
                _brands.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(
                      _brands[index],
                      style: TextStyle(
                        color: _selectedBrand == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: _selectedBrand == index,
                    onSelected: (bool selected) {
                      setState(() {
                        if (_selectedBrand == index) {
                          _selectedBrand = -1;
                          _selectedBrandName = null;
                        } else {
                          _selectedBrand = index;
                          _selectedBrandName = _brands[_selectedBrand];
                        }
                      });
                    },
                    selectedColor: defaultColor,
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).categories,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List<Widget>.generate(
                _categories.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(
                      _categories[index],
                      style: TextStyle(
                        color: _selectedCategory == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: _selectedCategory == index,
                    onSelected: (bool selected) {
                      setState(() {
                        if (_selectedCategory == index) {
                          _selectedCategory = -1;
                          _selectedCategoryName = null;
                        } else {
                          _selectedCategory = index;
                          _selectedCategoryName =
                              _categories[_selectedCategory];
                        }
                      });
                    },
                    selectedColor: defaultColor,
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).price,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: Stack(
                children: <Widget>[
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 2000,
                    activeColor: defaultColor,
                    inactiveColor: Colors.grey,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  Positioned(
                    left: getLeftPosition(_minPrice) + 16,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      color: themeProvider.isDarkMode
                          ? darkMoodColor
                          : Colors.white,
                      child: Text(
                        '${_minPrice.round()}IQD',
                        style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : darkMoodColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Positioned(
                    left: getLeftPosition(_maxPrice) + 16,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      color: themeProvider.isDarkMode
                          ? darkMoodColor
                          : Colors.white,
                      child: Text(
                        '${_maxPrice.round()}IQD',
                        style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : darkMoodColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${S.of(context).Selectedrange} ${_minPrice.round()} - ${_maxPrice.round()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedBrand = 1;
                        _selectedCategory = 1;
                        _minPrice = 100;
                        _maxPrice = 1200;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(S.of(context).Reset),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedBrandName == null &&
                          _selectedCategoryName != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => FilterResultScreen(
                            category: getCategoryId(_selectedCategoryName!),
                            min: _minPrice,
                            max: _maxPrice,
                          ),
                        ));
                      } else if (_selectedCategoryName == null &&
                          _selectedBrandName != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => FilterResultScreen(
                            brand: getBrandId(_selectedBrandName!),
                            min: _minPrice,
                            max: _maxPrice,
                          ),
                        ));
                      } else if (_selectedCategoryName == null &&
                          _selectedBrandName == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => FilterResultScreen(
                            min: _minPrice,
                            max: _maxPrice,
                          ),
                        ));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => FilterResultScreen(
                            brand: getBrandId(_selectedBrandName!),
                            category: getCategoryId(_selectedCategoryName!),
                            min: _minPrice,
                            max: _maxPrice,
                          ),
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: defaultColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(S.of(context).ApplyFilter),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
