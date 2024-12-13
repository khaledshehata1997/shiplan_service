class Product {
  final String name;
  final String image;
  final int id;
  final int stock;
  final bool isBestSeller;

  Product(
      {required this.name,
      required this.image,
      required this.id,
      required this.stock,
      required this.isBestSeller,
    });
}

class ProductsList {
  final List<dynamic> productsList;

  ProductsList({required this.productsList});
}