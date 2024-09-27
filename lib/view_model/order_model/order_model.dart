class OrderModel {
  final String id;
  final String maidId;
  final String maidName;
  final String maidCountry;
  final int visitCount;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String isDay;
  final String serviceType;
  final double price;
  final DateTime timestamp;

  OrderModel({
    required this.id,
    required this.maidId,
    required this.visitCount,
    required this.maidName,
    required this.maidCountry,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.isDay,
    required this.serviceType,
    required this.price,
    required this.timestamp,
  });

  // Factory method to create an Order instance from a Firestore document
  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'] ?? '',
      visitCount: data['visitCount'] ?? 0,
      maidId: data['maidId'] ?? '',
      maidName: data['maidName'] ?? '',
      maidCountry: data['maidCountry'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      isDay: data['serviceType'] ?? '',
      serviceType: data['serviceType'] ?? '',
      price: data['price'] ?? '',
      timestamp: DateTime.parse(data['timestamp']),
    );
  }

  // Convert an Order instance to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'maidId': maidId,
      'maidName': maidName,
      'maidCountry': maidCountry,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'serviceType': serviceType,
      'price': price,
      'isDay': isDay,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
