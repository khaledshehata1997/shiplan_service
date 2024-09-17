import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String serviceSummary;
  final String serviceType;
  final String maidId;
  final String maidCountry;
  final double regularPrice;
  final String description;
  final double priceAfterTax;
  final String title;
  final Map<String,String> freeDays;
  final bool dayOrNight;
  Service(
      {
        required this.dayOrNight,
        required this.maidId,
        required this.serviceSummary,
        required this.maidCountry,
        required this.serviceType,
        required this.description,
        required this.freeDays,
        required this.title,
        required this.id,
        required this.regularPrice,
        required this.priceAfterTax});

  factory Service.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    double parseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      } else {
        return 0.0;
      }
    }
    return Service(
      id: snapshot.id,
      regularPrice: parseDouble(data['regularPrice']),
      description: data['description'],
      title: data['title'],
      dayOrNight: data['dayOrNight'],
      maidId: data['maidId'],
      maidCountry: data['maidCountry'],
      serviceType: data['serviceType'],
      freeDays: data['freeDays'],
      priceAfterTax: data['priceAfterTax'],
      serviceSummary: data["serviceSummary"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'regularPrice': regularPrice,
      'description': description,
      'title' : title,
      'dayOrNight' : dayOrNight,
      'maidId' : maidId,
      'maidCountry' : maidCountry,
      'serviceType' : serviceType,
      'freeDays' : freeDays,
      'priceAfterTax' : priceAfterTax,
      'serviceSummary' :serviceSummary,
    };
  }

  Service copyWith({
    String? serviceSummary,
    double? regularPrice,
    String? description,
    String? title,
    bool? dayOrNight,
    String? maidId,
    String? maidCountry,
    String? serviceType,
    Map<String,String>? freeDays,
    double? priceAfterTax,

  }) {
    return Service(
      id: id,
      regularPrice: regularPrice ?? this.regularPrice,
      description: description ?? this.description,
      title: title ?? this.title,
      dayOrNight: dayOrNight ?? this.dayOrNight,
      maidId: maidId ?? this.maidId,
      maidCountry:  maidCountry ?? this.maidCountry,
      serviceType: serviceType ?? this.serviceType,
      freeDays: freeDays ?? this.freeDays,
      priceAfterTax: priceAfterTax ?? this.priceAfterTax,
      serviceSummary: serviceSummary ?? this.serviceSummary,

    );
  }
}

class ServicesService {
  Future<void> addService(
      {required String serviceSummary,
        required String title,
        required bool dayOrNight,
        required String serviceType,
        required String maidId,
        required String maidCountry,
        required Map<String,String> freeDays,
        required String description,
        required double regularPrice,
        required double priceAfterTax,
      }) async {
    final collection = FirebaseFirestore.instance.collection('services');
    await collection.add({
      "description" : description,
      'title': title,
      'regularPrice': regularPrice,
      'serviceSummary':serviceSummary,
      'dayOrNight' : dayOrNight,
      'serviceType' :serviceType,
      'maidId' : maidId,
      'maidCountry' : maidCountry,
      'freeDays' :freeDays,
      'priceAfterTax' : priceAfterTax,
    });
  }

  Stream<List<Service>> getProducts() {
    final collection = FirebaseFirestore.instance.collection('services');
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
    });
  }
  // Stream<List<Service>> getUnavailableProducts() {
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   return collection.where('avalible', isEqualTo: false).snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
  //   });
  // }
  // Future<void> productNotAvailable(String product) async {
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   return await collection.doc(product).update(
  //     {
  //       'avalible' : false,
  //     },
  //   );
  // }
  // Future<void> productAvailable(String product)async{
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   return await collection.doc(product).update(
  //     {
  //       'avalible' : true,
  //     },
  //   );
  // }


  // Future<void> addProductToBestSelling(Service product) async{
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   await collection.doc(product.id).update({
  //     "isbestselling" : true,
  //   });
  //
  //
  // }
  // Future<void> removeProductFromBestSelling(Service product) async{
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   await collection.doc(product.id).update({
  //     'isbestselling' : false,
  //   });
  // }
  // Future<void> addProductToFavorite(Service product) async{
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   await collection.doc(product.id).update({
  //     "favorite" : true,
  //   });
  //
  //
  // }
  // Future<void> removeProductFromFavorite(Service product) async{
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   await collection.doc(product.id).update({
  //     'favorite' : false,
  //   });
  // }
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<List<String>> getAllTokens() async {
    QuerySnapshot snapshot = await _db.collection('users').where('fcm', isNotEqualTo: null).get();

    List<String> tokens = snapshot.docs.map((doc) => doc['fcm'] as String).toList();

    return tokens;
  }

  // Stream<List<Service>> getProductsByCategory(String categoryId) {
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   return collection
  //       .where('categoryId', isEqualTo: categoryId)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
  //   });
  // }
  /*Future<void> removeProductFromBestSellingTest() async{
    final collection = FirebaseFirestore.instance.collection('products');
    await collection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.set({
          'isbestselling': false,
        },
        SetOptions(merge: true)
        );
      }
    });
  }

   */
  //delete Subcategory by id
  // Future<void> deleteSubcategory(String subcategoryId) async{
  //   final CollectionReference dataCollection =
  //   FirebaseFirestore.instance.collection('subcategories');
  //   await dataCollection.doc(subcategoryId).delete();
  // }
  // //delete Category by id
  // Future<void> deleteCategory(String categoryId) async{
  //   final CollectionReference dataCollection =
  //   FirebaseFirestore.instance.collection('categories');
  //   await dataCollection.doc(categoryId).delete();
  // }
  //delete Product by id
  Future<void> deleteProduct(String productId) async{
    final CollectionReference dataCollection =
    FirebaseFirestore.instance.collection('products');
    await dataCollection.doc(productId).delete();
  }
  // Future<void> deleteProductFromBestSelling(String productId) async{
  //   final CollectionReference dataCollection =
  //   FirebaseFirestore.instance.collection('bestselling');
  //   await dataCollection.doc(productId).delete();
  // }
  //
  // Stream<List<Service>> getProductsBySubcategory(String subcategoryId) {
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   return collection
  //       .where('subcategoryId', isEqualTo: subcategoryId)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
  //   });
  // }

  // get the best selling products

  // Stream<List<Service>> getBestSellingProducts() {
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   return collection
  //       .where('isbestselling', isEqualTo: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
  //   });
  // }
  // get the Favorite products

  // Stream<List<Service>> getFavoriteProducts() {
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   return collection
  //       .where('favorite', isEqualTo: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
  //   });
  // }
  // bool isArabic(String text) {
  //   final arabicRegex = RegExp(r'[\u0600-\u06FF]');
  //   return arabicRegex.hasMatch(text);
  // }
  // // search for a product
  // Stream<List<Service>> searchForProduct(String? productName, String? brandName) {
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   Query query = collection;
  //
  //   // Apply the title range query if the productName is provided
  //   if (isArabic(brandName!)) {
  //     query = query
  //         .where('title', isGreaterThanOrEqualTo: productName)
  //         .where('title', isLessThanOrEqualTo: '${productName!}\uf7ff');
  //   }
  //   else {
  //     query = query
  //         .where('brand', isGreaterThanOrEqualTo: brandName)
  //         .where('brand', isLessThanOrEqualTo: '$brandName\uf7ff');
  //   }
  //
  //   // Return the stream of products based on the dynamic query
  //   return query.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
  //   });
  // }


// update product
  Future<void> updateProduct(
      Service product,
      ) async {
    final collection = FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .update(product.toMap());

    await collection;


  }
  Future<Service> getProductById(String productId) async {
    final collection = FirebaseFirestore.instance.collection('products');
    final doc = await collection.doc(productId).get();
    return Service.fromSnapshot(doc);
  }
}