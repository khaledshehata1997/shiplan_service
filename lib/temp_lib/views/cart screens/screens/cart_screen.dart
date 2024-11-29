// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/cart_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/coupon_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/shipping_charge.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/models/cart.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/checkout_screen.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/widgets/cart_item.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart?> _cartFuture;
  double couponSale = 0;
  bool isApplyingCoupon = false;
  bool isDiscountApplied = false;
  final _couponController = TextEditingController();
  List<Map<String, dynamic>> coupons = [];
  double shippingCharge = 0;

  @override
  void initState() {
    super.initState();
    _cartFuture = Provider.of<CartController>(context, listen: false)
        .fetchCart(context, false);
    fetchShippingCharge();
    assignCoupon();
  }

  void fetchShippingCharge() async {
    final cubit = context.read<ShippingChargeController>();
    await cubit.fetchShippingCharge();
    shippingCharge = cubit.shippingCharge;
    setState(() {});
  }

  Future<void> assignCoupon() async {
    coupons = await Provider.of<CouponController>(context, listen: false)
        .fetchCoupons();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        appBar: AppBar(
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          title: Text(
            S.of(context).cart,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: FutureBuilder<Cart?>(
          future: _cartFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(S.of(context).noItemsSelected));
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.products.isEmpty) {
              return Center(child: Text(S.of(context).noItemsSelected));
            } else {
              var cartItem = snapshot.data!;
              return Consumer<CartController>(
                builder: (context, cartProvider, _) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(
                                cartItem.products.length,
                                (index) {
                                  Product product = cartItem.products[index];
                                  return CartItem(
                                    isCheckout: false,
                                    product: product,
                                    onDelete: () async {
                                      await cartProvider.removeFromCart(
                                          context, product);
                                      setState(() {
                                        _cartFuture = cartProvider.fetchCart(
                                            context, false);
                                      });
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isApplyingCoupon = !isApplyingCoupon;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(S.of(context).applyCoupon,
                                          style: const TextStyle(fontSize: 16)),
                                      Icon(isApplyingCoupon
                                          ? Icons.arrow_downward
                                          : Icons.arrow_forward_ios),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              isApplyingCoupon
                                  ? Consumer<CouponController>(
                                      builder: (context, couponProvider, _) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: TextField(
                                                controller: _couponController,
                                                decoration: inputDecoration(
                                                    S.of(context).enterCoupon),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool couponFound = false;
                                                final authService =
                                                    Provider.of<AuthService>(
                                                        context,
                                                        listen: false);
                                                String userId =
                                                    authService.user!.uid;

                                                DocumentSnapshot userSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('tempUsers')
                                                        .doc(userId)
                                                        .get();
                                                Map<String, dynamic> userData =
                                                    userSnapshot.data()
                                                        as Map<String, dynamic>;
                                                Map<String, dynamic>
                                                    couponUsage =
                                                    userData['couponUsage'] ??
                                                        {};

                                                for (var e in coupons) {
                                                  if (_couponController.text ==
                                                      e['name']) {
                                                    DateTime endDate =
                                                        (e['endDate']
                                                                as Timestamp)
                                                            .toDate();
                                                    int numberOfUses =
                                                        e['numberOfUse'];
                                                    String couponName =
                                                        e['name'];

                                                    if (DateTime.now()
                                                        .isBefore(endDate)) {
                                                      // Check if the coupon has uses left
                                                      if (numberOfUses > 0) {
                                                        // Show success message
                                                        showTopSnackBar(
                                                          context,
                                                          S
                                                              .of(context)
                                                              .couponApplied,
                                                          Icons.check_circle,
                                                          Colors.green,
                                                          const Duration(
                                                              seconds: 4),
                                                        );

                                                        setState(() {
                                                          couponSale = e['sale']
                                                              .toDouble();
                                                          couponFound = true;
                                                          isDiscountApplied =
                                                              true;
                                                        });

                                                        couponUsage[
                                                                couponName] =
                                                            (couponUsage[
                                                                        couponName] ??
                                                                    0) +
                                                                1;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'tempUsers')
                                                            .doc(userId)
                                                            .update({
                                                          'couponUsage':
                                                              couponUsage,
                                                        });

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'coupons')
                                                            .doc(e['id'])
                                                            .update({
                                                          'numberOfUse':
                                                              FieldValue
                                                                  .increment(
                                                                      -1),
                                                        });
                                                      } else {
                                                        showTopSnackBar(
                                                          context,
                                                          S
                                                              .of(context)
                                                              .Couponusagelimitreached,
                                                          Icons.error,
                                                          Colors.red,
                                                          const Duration(
                                                              seconds: 4),
                                                        );
                                                      }

                                                      couponFound = true;
                                                      break;
                                                    } else {
                                                      // Show message when the coupon has expired
                                                      showTopSnackBar(
                                                        context,
                                                        S
                                                            .of(context)
                                                            .Couponhasexpired,
                                                        Icons.error,
                                                        Colors.red,
                                                        const Duration(
                                                            seconds: 4),
                                                      );
                                                      couponFound = true;
                                                      break;
                                                    }
                                                  }
                                                }

                                                if (!couponFound) {
                                                  // Show message when the coupon is invalid
                                                  showTopSnackBar(
                                                    context,
                                                    S
                                                        .of(context)
                                                        .Couponisinvalid,
                                                    Icons.error,
                                                    Colors.red,
                                                    const Duration(seconds: 4),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: defaultColor,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: Text(S.of(context).apply),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(),
                              ),
                              const SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                child: Text(
                                  S.of(context).priceDetails,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).itemTotal,
                                        style: const TextStyle(fontSize: 16)),
                                    Text('${cartProvider.totalPrice}IQD',
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              couponSale != 0
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('discount',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.green)),
                                              Text('$couponSale%',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.green)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Consumer<ShippingChargeController>(
                                  builder: (context, shipping, _) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(S.of(context).shippingCharge,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        Text('${shipping.shippingCharge}IQD',
                                            style:
                                                const TextStyle(fontSize: 16)),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).total,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    couponSale != 0
                                        ? Text(
                                            '${(cartProvider.totalPrice + shippingCharge) - (cartProvider.totalPrice) * (couponSale / 100)}IQD',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          )
                                        : Text(
                                            '${(cartProvider.totalPrice + shippingCharge)}IQD'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          bool isValid = true;
                          for (var e in cartItem.products) {
                            if (e.stock == 0) {
                              setState(() {
                                isValid = false;
                              });
                            }
                          }
                          if (isValid) {
                            final authService = Provider.of<AuthService>(
                                context,
                                listen: false);
                            if (authService.isUserLoggedIn) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => CheckoutScreen(
                                  shippingCharge: shippingCharge,
                                  couponSale: couponSale,
                                  selectedItems: cartItem.products.length,
                                  products: cartItem.products,
                                  itemTotal: cartProvider.totalPrice,
                                  total: couponSale != 0
                                      ? (cartProvider.totalPrice +
                                              shippingCharge) -
                                          (cartProvider.totalPrice) *
                                              (couponSale / 100)
                                      : cartProvider.totalPrice +
                                          shippingCharge,
                                ),
                              ));
                            } else {
                              authService.showLoginDialog(context);
                            }
                          } else {
                            showTopSnackBar(
                              context,
                              S.of(context).thisproductisoutofstock,
                              Icons.check_circle,
                              defaultColor,
                              const Duration(seconds: 4),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              S.of(context).checkout,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      labelText: labelText, // Dynamic labelText
      labelStyle: TextStyle(color: Colors.grey.shade400),
    );
  }
}
