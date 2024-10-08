import 'package:cloud_firestore/cloud_firestore.dart';

class MaidModel {
  String id; // Firestore document ID
  String name;
  int age;
  String country;
  String imageUrl;
  String cvUrl;

  MaidModel({
    required this.id,
    required this.name,
    required this.age,
    required this.country,
    required this.imageUrl,
    required this.cvUrl,
  });

  // Convert a Maid object into a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'id': id,
      'country': country,
      'imageUrl': imageUrl,
      'cvUrl':cvUrl

    };
  }

  // Create a Maid object from Firebase document data
  factory MaidModel.fromMap(String id, Map<String, dynamic> data) {
    return MaidModel(
      id: id,
      name: data['name'],
      age: data['age'],
      country: data['country'],
      imageUrl: data['imageUrl'],
      cvUrl: data['cvUrl']
    );
  }
}
Future<void> addMaid(MaidModel maid) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('maids').add(maid.toMap());
  } catch (e) {
    print("Error adding maid: $e");
  }
}
Future<void> updateMaid(MaidModel maid) async {
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

