
class Product {
  final String name;
  final String nameAr;
  final double price;
  final String image;
  final String? id;
  final String? categoryId;
  final String? brandId;
  final int? stock;
  final int sold;
  final String? description;
  final String? arDescription;
  final List<dynamic>? optionImages;
  final List<dynamic> colors;
  final List<dynamic> colorsQuantity;
  final int? selectedColor;
  final int? selectedColorIndex;
  int quantityInCart;

  Product({
    required this.name,
    required this.nameAr,
    required this.price,
    required this.image,
    this.id,
    this.categoryId,
    this.brandId,
    this.stock,
    this.description,
    required this.sold,
    this.quantityInCart = 1,
    required this.optionImages,
    required this.colors,
    required this.colorsQuantity,
    required this.arDescription,
    this.selectedColor,
    this.selectedColorIndex
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      nameAr: map['nameAr'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
      id: map['id'],
      categoryId: map['categoryId'],
      brandId: map['brandId'],
      stock: map['stock']?.toInt(),
      sold: map['sold'].toInt(),
      description: map['description'],
      quantityInCart: map['quantityInCart'],
      optionImages: map['optionImages'],
      colors: map['colors'],
      colorsQuantity: map['colorsQuantity'],
      arDescription: map['arDescription'],
      selectedColor: map['selectedColor'],
      selectedColorIndex: map['selectedColorIndex']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAr' : nameAr,
      'price': price,
      'image': image,
      'categoryId': categoryId,
      'brandId': brandId,
      'id' : id,
      'description' : description,
      'stock': stock,
      'sold' : sold,
      'quantityInCart' : quantityInCart,
      'optionImages' : optionImages,
      'colors' : colors,
      'colorsQuantity' : colorsQuantity,
      'arDescription' : arDescription,
      'selectedColor' : selectedColor,
      'selectedColorIndex' : selectedColorIndex
    };
  }
}
