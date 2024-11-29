import 'package:shiplan_service/temp_lib/models/product.dart';

class Favorites {
  final List<Product> products;
  final String userId;

  Favorites({required this.products, required this.userId});

  factory Favorites.fromMap(Map<String, dynamic> map) => Favorites(
        products: List<Product>.from(
          map['products'].map((product) => Product.fromMap(product)),
        ),
        userId: map['userId'],
      );

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((product) => product.toMap()).toList(),
      'userId': userId,
    };
  }
}
