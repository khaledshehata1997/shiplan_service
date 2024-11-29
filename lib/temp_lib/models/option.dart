class Option {
  String color;
  int quantity;

  Option({required this.color, required this.quantity});

  // Convert Option to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'quantity': quantity,
    };
  }
}
