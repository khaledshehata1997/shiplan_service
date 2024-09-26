import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String serviceSummary;
  final int hours;
  final int vistCount;
  final String serviceType;
  final String maidId;
  final String maidCountry;
  final double regularPrice;
  final String description;
  final double priceAfterTax;
  final String title;
  final bool isDay;
  final Map<String, Map<String, String>> freeDays;

  ServiceModel(
      {required this.maidId,
      required this.vistCount,
      required this.isDay,
      required this.hours,
      required this.serviceSummary,
      required this.maidCountry,
      required this.serviceType,
      required this.description,
      required this.freeDays,
      required this.title,
      required this.id,
      required this.regularPrice,
      required this.priceAfterTax});

  factory ServiceModel.fromMap(Map<String, dynamic> data) {
    return ServiceModel(
      id: data['id'] ?? '',
      hours: data['hours'] ?? 0,
      vistCount: data['vistCount'] ?? 0,
      isDay: data['isDay'] ?? false,
      serviceSummary: data['serviceSummary'] ?? '',
      serviceType: data['serviceType'] ?? '',
      maidId: data['maidId'] ?? '',
      maidCountry: data['maidCountry'] ?? '',
      regularPrice: data['regularPrice'].toDouble() ?? 0.0,
      description: data['description'] ?? '',
      priceAfterTax: data['priceAfterTax'].toDouble() ?? 0.0,
      title: data['title'] ?? '',
      freeDays: (data['freeDays'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(
          key,
          Map<String, String>.from(value as Map), // Cast the inner map
        );
      }),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'regularPrice': regularPrice,
      'description': description,
      'hours': hours,
      'id': id,
      'vistCount': vistCount,
      'isDay': isDay,
      'title': title,
      'maidId': maidId,
      'maidCountry': maidCountry,
      'serviceType': serviceType,
      'freeDays': freeDays,
      'priceAfterTax': priceAfterTax,
      'serviceSummary': serviceSummary,
    };
  }
}

class ServicesService {
//day services
  static void addDayService(ServiceModel newService) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('services').doc('day');

    // First, get the current list of services
    DocumentSnapshot docSnapshot = await documentReference.get();

    // If the document exists, retrieve the current list of services
    List<dynamic> servicesList = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      servicesList =
          (docSnapshot.data() as Map<String, dynamic>)['services'] ?? [];
    }

    // Add the new service to the list
    servicesList.add(newService.toMap());

    // Update the document with the new list of services
    await documentReference.set({
      'services': servicesList,
    }, SetOptions(merge: true)).then((value) {
      print("Service successfully added!");
    }).catchError((error) {
      print("Failed to add service: $error");
    });
  }
    static void addDayOffersService(ServiceModel newService) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('offers').doc('day');

    // First, get the current list of services
    DocumentSnapshot docSnapshot = await documentReference.get();

    // If the document exists, retrieve the current list of services
    List<dynamic> servicesList = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      servicesList =
          (docSnapshot.data() as Map<String, dynamic>)['offers'] ?? [];
    }

    // Add the new service to the list
    servicesList.add(newService.toMap());

    // Update the document with the new list of services
    await documentReference.set({
      'offers': servicesList,
    }, SetOptions(merge: true)).then((value) {
      print("offers successfully added!");
    }).catchError((error) {
      print("Failed to add service: $error");
    });
  }

  static void addRentDayService(ServiceModel newService) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('rent').doc('day');

    // First, get the current list of services
    DocumentSnapshot docSnapshot = await documentReference.get();

    // If the document exists, retrieve the current list of services
    List<dynamic> servicesList = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      servicesList =
          (docSnapshot.data() as Map<String, dynamic>)['rentService'] ?? [];
    }

    // Add the new service to the list
    servicesList.add(newService.toMap());

    // Update the document with the new list of services
    await documentReference.set({
      'rentService': servicesList,
    }, SetOptions(merge: true)).then((value) {
      print("Service successfully added!");
    }).catchError((error) {
      print("Failed to add service: $error");
    });
  }
   static void addRentDayOffersService(ServiceModel newService) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('rentOffers').doc('day');

    // First, get the current list of services
    DocumentSnapshot docSnapshot = await documentReference.get();

    // If the document exists, retrieve the current list of services
    List<dynamic> servicesList = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      servicesList =
          (docSnapshot.data() as Map<String, dynamic>)['rentOffersService'] ?? [];
    }

    // Add the new service to the list
    servicesList.add(newService.toMap());

    // Update the document with the new list of services
    await documentReference.set({
      'rentService': servicesList,
    }, SetOptions(merge: true)).then((value) {
      print("Service successfully added!");
    }).catchError((error) {
      print("Failed to add service: $error");
    });
  }

  static void addRentNightService(ServiceModel newService) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('rentOffers').doc('night');

    // First, get the current list of services
    DocumentSnapshot docSnapshot = await documentReference.get();

    // If the document exists, retrieve the current list of services
    List<dynamic> servicesList = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      servicesList =
          (docSnapshot.data() as Map<String, dynamic>)['rentService'] ?? [];
    }

    // Add the new service to the list
    servicesList.add(newService.toMap());

    // Update the document with the new list of services
    await documentReference.set({
      'rentService': servicesList,
    }, SetOptions(merge: true)).then((value) {
      print("Service successfully added!");
    }).catchError((error) {
      print("Failed to add service: $error");
    });
  }
    static void addRentNightOffersService(ServiceModel newService) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('rentOffers').doc('night');

    // First, get the current list of services
    DocumentSnapshot docSnapshot = await documentReference.get();

    // If the document exists, retrieve the current list of services
    List<dynamic> servicesList = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      servicesList =
          (docSnapshot.data() as Map<String, dynamic>)['rentService'] ?? [];
    }

    // Add the new service to the list
    servicesList.add(newService.toMap());

    // Update the document with the new list of services
    await documentReference.set({
      'rentService': servicesList,
    }, SetOptions(merge: true)).then((value) {
      print("Service successfully added!");
    }).catchError((error) {
      print("Failed to add service: $error");
    });
  }

//night services
  static void addNightService(ServiceModel newService) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('services').doc('night');

    // First, get the current list of services
    DocumentSnapshot docSnapshot = await documentReference.get();

    // If the document exists, retrieve the current list of services
    List<dynamic> servicesList = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      servicesList =
          (docSnapshot.data() as Map<String, dynamic>)['services'] ?? [];
    }

    // Add the new service to the list
    servicesList.add(newService.toMap());

    // Update the document with the new list of services
    await documentReference.set({
      'services': servicesList,
    }, SetOptions(merge: true)).then((value) {
      print("Service successfully added!");
    }).catchError((error) {
      print("Failed to add service: $error");
    });
  }
 static void addNightOffersService(ServiceModel newService) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('offers').doc('night');

    // First, get the current list of services
    DocumentSnapshot docSnapshot = await documentReference.get();

    // If the document exists, retrieve the current list of services
    List<dynamic> servicesList = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      servicesList =
          (docSnapshot.data() as Map<String, dynamic>)['offers'] ?? [];
    }

    // Add the new service to the list
    servicesList.add(newService.toMap());

    // Update the document with the new list of services
    await documentReference.set({
      'services': servicesList,
    }, SetOptions(merge: true)).then((value) {
      print("offers successfully added!");
    }).catchError((error) {
      print("Failed to add service: $error");
    });
  }
  Stream<List<ServiceModel>> getProducts() {
    final collection = FirebaseFirestore.instance.collection('services');
    return collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceModel.fromMap(doc.data()))
          .toList();
    });
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<List<String>> getAllTokens() async {
    QuerySnapshot snapshot =
        await _db.collection('users').where('fcm', isNotEqualTo: null).get();

    List<String> tokens =
        snapshot.docs.map((doc) => doc['fcm'] as String).toList();

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
  Future<void> deleteProduct(String productId) async {
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
    ServiceModel product,
  ) async {
    final collection = FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .update(product.toMap());

    await collection;
  }

  // Future<ServiceModel> getProductById(String productId) async {
  //   final collection = FirebaseFirestore.instance.collection('products');
  //   final doc = await collection.doc(productId).get();
  //   return ServiceModel.fromMap(doc.data());
  // }
}
