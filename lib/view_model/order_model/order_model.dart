class OrderModel {
  final String maidId;
  final String maidName;
  final String fullName;
  final String phoneNumber;
  final String address;
  final DateTime timestamp;

  OrderModel({
    required this.maidId,
    required this.maidName,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.timestamp,
  });

  // Factory method to create an Order instance from a Firestore document
  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      maidId: data['maidId'] ?? '',
      maidName: data['maidName'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      timestamp: DateTime.parse(data['timestamp']),
    );
  }

  // Convert an Order instance to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'maidId': maidId,
      'maidName': maidName,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
