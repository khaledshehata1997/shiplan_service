import 'package:shiplan_service/temp_admin_lib/models/product_model.dart';

class Category {
  final String name;
  final int id;
  final String image;
  final List<Product> products;

  Category({
    required this.name,
    required this.id,
    required this.image,
    required this.products,
  });
}

class CategoriesList {
  final List<dynamic> categoriesList;

  CategoriesList({required this.categoriesList});
}
