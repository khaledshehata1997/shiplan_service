import 'package:cloud_firestore/cloud_firestore.dart';

class Khadamat {
  var  id;
  var  title;
   var description;
   var regularPrice;

  Khadamat({ this.title, this.id,  this.description,  this.regularPrice});

  factory Khadamat.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Khadamat(
      id: snapshot.id,
      title: data['title'],
      regularPrice: data['RegularPrice'],
      description: data['description']
    );
  }

  @override
  String toString() => "Category<$id:$title>";

  Map<String, Object?> toDocument() {
    return {
      'title': title,
    };
  }

  Khadamat copyWith({
    String? id,
    String? name,
  })
  {
    return Khadamat(
      id: id ?? this.id,
      title: name ?? this.title,
      regularPrice: regularPrice,
      description: description
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Khadamat &&
        other.id == id &&
        other.title == title ;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}

class CategoryService {
  final CollectionReference _categoryCollectionRef =
  FirebaseFirestore.instance.collection('services');

// get Category
  Future<Khadamat> getCategory(String id) async {
    final doc = await _categoryCollectionRef.doc(id).get();
    return Khadamat.fromSnapshot(doc);
  }

  Stream<List<Khadamat>> getCategories() {
    final collection = FirebaseFirestore.instance.collection('services');
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Khadamat.fromSnapshot(doc)).toList();
    });
  }

  // add a category

  // get a category by id
  Future<Khadamat> getCategoryById(String id) async {
    final doc = await _categoryCollectionRef.doc(id).get();
    return Khadamat.fromSnapshot(doc);
  }

  // update a category
  Future<void> updateCategory(
      Khadamat category,
      ) async {
    final collection = FirebaseFirestore.instance
        .collection('services')
        .doc(category.id)
        .update(category.toDocument());

    await collection;


  }
}
