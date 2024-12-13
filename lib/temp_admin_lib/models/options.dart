class Option {
  final int color;
  int quantity;
  String image;
  final String productId;
  

  Option({required this.color, required this.quantity, required this.image,required this.productId});

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'quantity': quantity,
      'image' : image,
      'productId' : productId
    };
  }
}
