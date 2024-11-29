import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_lib/models/favorties.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';

class FavoritesController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> favorites = [];

  Future<void> addToFavorites(String userId, Product product) async {
    try {
      DocumentReference userFavoritesDoc =
          _firestore.collection('favorites').doc(userId);

      DocumentSnapshot snapshot = await userFavoritesDoc.get();
      Favorites favorites;

      if (snapshot.exists) {
        favorites = Favorites.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        favorites = Favorites(products: [], userId: userId);
      }

      if (!favorites.products.any((p) => p.id == product.id)) {
        favorites.products.add(product);
        await userFavoritesDoc.set(favorites.toMap());
      }
    } catch (e) {
      log("Error adding to favorites: $e");
    }
  }

  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      DocumentReference userFavoritesDoc =
          _firestore.collection('favorites').doc(userId);

      DocumentSnapshot snapshot = await userFavoritesDoc.get();
      Favorites favs;

      if (snapshot.exists) {
        favs = Favorites.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        favs = Favorites(products: [], userId: userId);
      }

      favs.products.removeWhere((product) => product.id == productId);

      await userFavoritesDoc.set(favs.toMap());
    } catch (e) {
      log("Error removing from favorites: $e");
    }
  }

  Future<void> getFavorites(String userId) async {
    try {
      DocumentReference userFavoritesDoc =
          _firestore.collection('favorites').doc(userId);

      DocumentSnapshot snapshot = await userFavoritesDoc.get();

      if (snapshot.exists) {
        Favorites favorite =
            Favorites.fromMap(snapshot.data() as Map<String, dynamic>);
        favorites = favorite.products;
        notifyListeners();
      } else {}
    } catch (e) {
      log("Error getting favorites: $e");
    }
  }
}
