import 'package:shiplan_service/temp_lib/models/product.dart';

class Cart {
  final List<Product> products;
  final String userId;

  Cart({required this.products, required this.userId});

  factory Cart.fromMap(Map<String, dynamic> map) => Cart(
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
