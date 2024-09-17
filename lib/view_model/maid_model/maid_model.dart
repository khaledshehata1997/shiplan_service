import 'package:cloud_firestore/cloud_firestore.dart';

class Maid {
  String id; // Firestore document ID
  String name;
  int age;
  String country;
  String imageUrl;

  Maid({
    required this.id,
    required this.name,
    required this.age,
    required this.country,
    required this.imageUrl,
  });

  // Convert a Maid object into a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'country': country,
      'imageUrl': imageUrl,
    };
  }

  // Create a Maid object from Firebase document data
  factory Maid.fromMap(String id, Map<String, dynamic> data) {
    return Maid(
      id: id,
      name: data['name'],
      age: data['age'],
      country: data['country'],
      imageUrl: data['imageUrl'],
    );
  }
}
Future<void> addMaid(Maid maid) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('maids').add(maid.toMap());
  } catch (e) {
    print("Error adding maid: $e");
  }
}
Future<void> updateMaid(Maid maid) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('maids').doc(maid.id).update(maid.toMap());
  } catch (e) {
    print("Error updating maid: $e");
  }
}
Future<void> deleteMaid(String maidId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('maids').doc(maidId).delete();
  } catch (e) {
    print("Error deleting maid: $e");
  }
}

