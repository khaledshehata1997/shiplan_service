// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/oreders_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/models/cart.dart';
import 'package:shiplan_service/temp_lib/models/orders.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';

class CartController with ChangeNotifier {
  double totalPrice = 0;
  List<double> prices = [];
  List<Cart> cart = [];
  Cart? cartItem;
  List<Product> productListed = [];
  String orderId = '';

  void setNewTotalPrice(double itemPrice, bool isIncreament) {
    if (isIncreament) {
      totalPrice += itemPrice;
    } else {
      totalPrice -= itemPrice;
    }
    notifyListeners();
  }

  Future<void> addToCart(BuildContext context) async {
    CollectionReference cartCollection =
        FirebaseFirestore.instance.collection('cart');
    final userData = Provider.of<AuthService>(context, listen: false).user;

    if (userData == null) {
      log("User not found");
      return;
    }

    // Convert the product list to a map with each product having a unique identifier for the combination of id and color
    List<Map<String, dynamic>> productListData = productListed.map((product) {
      Map<String, dynamic> productMap = product.toMap();
      // Assuming 'selectedColor' holds the currently chosen color by the user for each product
      if (product.colors.isNotEmpty) {
        productMap['selectedColor'] = product.colors[
            Provider.of<ProductController>(context, listen: false)
                .selectedOptionIndex!];
      }
      return productMap;
    }).toList();

    if (productListData.isEmpty) {
      return;
    }

    QuerySnapshot existingCartSnapshot = await cartCollection
        .where('userId', isEqualTo: userData.uid)
        .limit(1)
        .get();

    if (existingCartSnapshot.docs.isNotEmpty) {
      // Get the existing cart document
      DocumentReference existingCartDoc =
          existingCartSnapshot.docs.first.reference;
      Map<String, dynamic> existingCartData =
          existingCartSnapshot.docs.first.data() as Map<String, dynamic>;
      List<dynamic> existingProducts = existingCartData['products'] ?? [];

      // Convert existing products to map for easier manipulation
      List<Map<String, dynamic>> updatedProducts =
          existingProducts.map((e) => Map<String, dynamic>.from(e)).toList();

      // Iterate over new products and update quantities if they already exist in the cart
      for (var newProduct in productListData) {
        bool productExists = false;

        for (var existingProduct in updatedProducts) {
          // Compare using both product ID and selected color to handle variants correctly
          if (existingProduct['id'] == newProduct['id'] &&
              existingProduct['selectedColor'] == newProduct['selectedColor']) {
            existingProduct['quantityInCart'] += newProduct['quantityInCart'];
            productExists = true;
            break;
          }
        }

        // If the product variant does not exist in the cart, add it as a new variant
        if (!productExists) {
          updatedProducts.add(newProduct);
        }
      }

      // Update the cart in Firestore with the updated product list
      await existingCartDoc.update({
        'products': updatedProducts,
      }).then((_) {
        log("Products updated in existing cart with ID: ${existingCartDoc.id}");
      }).catchError((error) {
        log("Error updating products in cart: $error");
      });
    } else {
      // Create a new cart document
      await cartCollection.add({
        'products': productListData,
        'userId': userData.uid,
      }).then((docRef) {
        log("New cart created with ID: ${docRef.id}");
      }).catchError((error) {
        log("Error creating new cart: $error");
      });
    }

    // Clear the local product list after adding to the cart
    productListed.clear();
    notifyListeners();
  }

  Future<void> removeFromCart(BuildContext context, Product product) async {
    CollectionReference cart = FirebaseFirestore.instance.collection('cart');
    final userData = Provider.of<AuthService>(context, listen: false).user;

    if (userData == null) {
      log("User not found");
      return;
    }

    productListed.removeWhere((e) => e.id == product.id);

    QuerySnapshot existingCartSnapshot =
        await cart.where('userId', isEqualTo: userData.uid).limit(1).get();

    if (existingCartSnapshot.docs.isNotEmpty) {
      DocumentReference existingCartDoc =
          existingCartSnapshot.docs.first.reference;

      await existingCartDoc.update({
        'products': FieldValue.arrayRemove([product.toMap()]),
      }).then((_) {
        log("Product removed from cart with ID: ${product.id}");
      }).catchError((error) {
        log("Error removing product from cart: $error");
      });
    } else {
      log("Cart not found for user ${userData.uid}");
    }

    notifyListeners();
  }

  void addProductsToList(Product product) {
    bool productExists = false;

    // Iterate through the existing products in the list
    for (var existingProduct in productListed) {
      // Check if the IDs match to identify the same product
      if (existingProduct.id == product.id) {
        // Increment the quantity of the existing product
        existingProduct.quantityInCart += product.quantityInCart;
        productExists = true;
        break; // Exit the loop after updating the quantity
      }
    }

    // If the product is not found in the list, add it as a new item
    if (!productExists) {
      productListed.add(product);
    }

    notifyListeners();
  }

  Future<Cart?> fetchCart(BuildContext context, bool isDetails,
      {double pickedPrice = 0}) async {
    final userData = Provider.of<AuthService>(context, listen: false).user;
    try {
      if (userData == null) {
        cart.clear();
        return null;
      } else {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('cart').get();
        List<Cart> fetchedCart = [];
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> cartData = doc.data() as Map<String, dynamic>;
          cartData['id'] = doc.id;
          fetchedCart.add(Cart.fromMap(cartData));
          cart = fetchedCart;
          notifyListeners();
        }
        cartItem = cart.firstWhere(
          (element) => element.userId == userData.uid,
        );
        if (isDetails) {
          totalPrice = 0;
          totalPrice = pickedPrice;
        } else {
          totalPrice = 0;
          for (var e in cartItem!.products) {
            totalPrice = totalPrice + (e.price * e.quantityInCart);
          }
        }
        return cartItem;
      }
    } catch (e) {
      log("Error fetching cart: $e");
    }
    throw Exception();
  }

  Future<void> deleteCartAfterPurchase(BuildContext context,
      {double? totalPrice,
      required String address,
      required String phoneNumber,
      required String paymentType}) async {
    CollectionReference cartCollection =
        FirebaseFirestore.instance.collection('cart');
    CollectionReference productsCollection =
        FirebaseFirestore.instance.collection('products');
    final userData = Provider.of<AuthService>(context, listen: false).user;

    if (userData == null) {
      log("User not found");
      return;
    }

    QuerySnapshot existingCartSnapshot = await cartCollection
        .where('userId', isEqualTo: userData.uid)
        .limit(1)
        .get();

    if (existingCartSnapshot.docs.isNotEmpty) {
      DocumentReference existingCartDoc =
          existingCartSnapshot.docs.first.reference;

      if (cartItem != null) {
        List<String> productNames = [];
        List<String> productIds = [];
        List<String> productImages = [];
        List<int> productQuantities = [];
        List<double> productPrices = [];
        int? selectedColorIndex =
            Provider.of<ProductController>(context, listen: false)
                .selectedOptionIndex;
        // double totalPrice = 0.0;

        for (var product in cartItem!.products) {
          DocumentReference productDoc = productsCollection.doc(product.id);

          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapshot = await transaction.get(productDoc);

            if (snapshot.exists) {
              int currentStock = snapshot['stock'];
              int currentSold = snapshot['sold'];
              selectedColorIndex = product.selectedColorIndex ?? 0;
              int quantityInCart = product.quantityInCart;
              List<int> colorQuantities = [];
              if (product.colors.isNotEmpty) {
                // Fetch color quantities and update the selected color quantity
                colorQuantities = List<int>.from(snapshot['colorsQuantity']);
                if (colorQuantities.length > selectedColorIndex!) {
                  colorQuantities[selectedColorIndex!] -= quantityInCart;
                } else {
                  log("Color index out of range for product: ${product.name}");
                }
              }
              if (currentStock >= quantityInCart) {
                // Update stock and sold quantities
                transaction.update(productDoc, {
                  'stock': currentStock - quantityInCart,
                  'sold': currentSold + quantityInCart,
                  'colorsQuantity': colorQuantities,
                });

                // Add product info to order details
                final langController =
                    Provider.of<LangController>(context, listen: false);
                productNames.add(
                    langController.isArabic ? product.nameAr : product.name);
                productIds.add(product.id!);
                productImages.add(product.image);
                productQuantities.add(quantityInCart);
                productPrices.add(product.price);
                // totalPrice += quantityInCart * product.price;
              } else {
                log("Not enough stock for product: ${product.name}");
              }
            } else {
              log("Product does not exist: ${product.name}");
            }
          }).catchError((error) {
            log("Error updating product stock and sold: $error");
          });
        }

        log('selectedColorIndex: $selectedColorIndex');

        // Create order object
        Orders newOrder = Orders(
          timestamp: Timestamp.now(),
          id: Orders.generateRandomId(),
          productName: productNames,
          productIds: productIds,
          image: productImages,
          qty: productQuantities,
          productPrice: productPrices,
          totalPrice: totalPrice!,
          userId: userData.uid,
          status: "Pending",
          address: address,
          phoneNumber: phoneNumber,
          selectedOptionIndex: selectedColorIndex,
          paymentType: paymentType,
        );

        Provider.of<OrdersController>(context, listen: false)
            .addOrderToFirestore(newOrder);

        // Delete the cart
        await existingCartDoc.delete().then((_) {
          log("Cart deleted for user: ${userData.uid}");
          cartItem = null;
          cart.clear();
          productListed.clear();
          totalPrice = 0;
        }).catchError((error) {
          log("Error deleting cart: $error");
        });
      }
    } else {
      log("No cart found to delete for user ${userData.uid}");
    }

    notifyListeners();
  }
}
