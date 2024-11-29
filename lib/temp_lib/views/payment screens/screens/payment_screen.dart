// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/cart_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/oreders_controller.dart';
// import 'package:shiplan_service/temp_lib/controllers/paytabs_services.dart';
import 'package:shiplan_service/temp_lib/controllers/zain_cash_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/models/orders.dart';
import 'package:shiplan_service/temp_lib/views/payment%20screens/track_order_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/tabs_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key,
      required this.total,
      required this.itemTotal,
      required this.address,
      required this.phoneNumber,
      required this.couponSale,
      required this.shippingCharge});
  final double total;
  final double itemTotal;
  final String address;
  final String phoneNumber;
  final double couponSale;
  final double shippingCharge;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 1;
  String transactionId = '';
  bool isZainshowed = false;
  String userEmail = '';
  String userPhone = '';
  String userName = '';
  bool isLoading = false;
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> pushNotfiToAdmin() async {
    final QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('tempUsers')
        .where("role", isEqualTo: 'admin')
        .get();

    if (data.docs.isNotEmpty) {
      for (QueryDocumentSnapshot data in data.docs) {
        if (data['fcmToken'] != null && data['fcmToken'].isNotEmpty) {}
      }
    }
  }

  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('tempUsers')
            .doc(currentUser.uid)
            .get();

        if (userSnapshot.exists) {
          setState(() {
            userEmail = userSnapshot['email'] ?? 'No Email';
            userPhone = userSnapshot['phoneNumber'] ?? 'No Phone';
            userName = userSnapshot['username'] ?? 'No UserName';
          });
        }
      }
    } catch (e) {
      log("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (isClicked) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (ctx) => const TabsScreen(isLoggedIn: true)),
          );
          return false;
        } else {
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          appBar: AppBar(
            backgroundColor:
                themeProvider.isDarkMode ? darkMoodColor : Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              S.of(context).paymentMethod,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cash on Delivery
                        RadioListTile(
                          activeColor: defaultColor,
                          contentPadding: const EdgeInsets.all(0),
                          value: 1,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Row(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/cashondeliverynew.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                              const SizedBox(width: 10),
                              Text(S.of(context).cashOnDelivery),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 15),
                        // RadioListTile(
                        //   activeColor: defaultColor,
                        //   contentPadding: const EdgeInsets.all(0),
                        //   value: 2,
                        //   groupValue: _selectedPaymentMethod,
                        //   onChanged: (int? value) {
                        //     setState(() {
                        //       _selectedPaymentMethod = value!;
                        //     });
                        //   },
                        //   controlAffinity: ListTileControlAffinity.trailing,
                        //   title: Row(
                        //     children: [
                        //       Container(
                        //           padding:
                        //               const EdgeInsets.symmetric(horizontal: 10),
                        //           height: 50,
                        //           width: 50,
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(10),
                        //             color: Colors.grey.shade200,
                        //           ),
                        //           child: SvgPicture.asset('assets/Mastercard.svg')),
                        //       const SizedBox(width: 10),
                        //       const Text('Master Card'),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        Divider(
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(widget.address),
                        const SizedBox(height: 10),
                        Text(widget.phoneNumber),
                        const SizedBox(height: 10),
                        Text(userEmail),
                        const SizedBox(height: 20),
                        // Price Details
                        Text(S.of(context).priceDetails,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).itemTotal),
                            Text('${widget.itemTotal}IQD'),
                          ],
                        ),
                        widget.couponSale != 0
                            ? Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('dicount',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green)),
                                      Text('${widget.couponSale}%',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.green)),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).shippingCharge),
                            Text('${widget.shippingCharge} IQD'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).total,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('${widget.total}IQD',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            isClicked = true;
                          });
                          if (_selectedPaymentMethod == 0) {
                            if (widget.total < 1000) {
                              showTopSnackBar(
                                context,
                                S.of(context).you_cant_buy_with_less_than_1000,
                                Icons.check_circle,
                                defaultColor,
                                const Duration(seconds: 4),
                              );
                            } else {
                              transactionId =
                                  await Provider.of<ZainCashController>(context,
                                          listen: false)
                                      .initiateZainCashTransaction(
                                          widget.total);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } else if (_selectedPaymentMethod == 1) {
                            await Provider.of<CartController>(context,
                                    listen: false)
                                .deleteCartAfterPurchase(
                              context,
                              totalPrice: widget.total,
                              address: widget.address,
                              phoneNumber: widget.phoneNumber,
                              paymentType: 'Cash On Delivery',
                            );
                            User? user = FirebaseAuth.instance.currentUser;
                            DocumentReference userRef = FirebaseFirestore
                                .instance
                                .collection('tempUsers')
                                .doc(user!.uid);
                            DocumentSnapshot userSnapshot = await userRef.get();
                            if (userSnapshot.exists) {
                              Map<String, dynamic> userData =
                                  userSnapshot.data() as Map<String, dynamic>;
                              if (userData['buyer'] == false) {
                                await userRef.update({'buyer': true});
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                            showOrderConfirmationDialog(context, true);
                            pushNotfiToAdmin();
                          }
                          // else if (_selectedPaymentMethod == 2) {
                          //   final paytabsService =
                          //       Provider.of<PaytabsServices>(context, listen: false);
                          //   try {
                          //     await paytabsService
                          //         .handlePayment(FlutterPaytabsBridge.startCardPayment);
                          //     if (paytabsService.isDone) {
                          //       await Provider.of<CartController>(context,
                          //               listen: false)
                          //           .deleteCartAfterPurchase(context,
                          //               totalPrice: widget.total,
                          //               address: widget.address,
                          //               phoneNumber: widget.phoneNumber);
                          //       showOrderConfirmationDialog(context, true);
                          //       User? user = FirebaseAuth.instance.currentUser;
                          //         DocumentReference userRef = FirebaseFirestore.instance
                          //             .collection('tempUsers')
                          //             .doc(user!.uid);
                          //         DocumentSnapshot userSnapshot = await userRef.get();
                          //         if (userSnapshot.exists) {
                          //           Map<String, dynamic> userData =
                          //               userSnapshot.data() as Map<String, dynamic>;
                          //           if (userData['buyer'] == false) {
                          //             await userRef.update({'buyer': true});
                          //           }
                          //         }
                          //     } else {
                          //       showOrderConfirmationDialog(context, false);
                          //     }
                          //   } catch (e) {
                          //     showOrderConfirmationDialog(context, false);
                          //   }
                          // }
                        },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: defaultColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : Text(S.of(context).payNow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showOrderConfirmationDialog(BuildContext context, bool isDone) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink.shade50,
                ),
                child: Center(
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                      color: defaultColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: SvgPicture.asset(
                      'assets/shopping-cart.svg',
                      width: 32,
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                isDone
                    ? S.of(context).orderPlaceSuccessfully
                    : S.of(context).transactionfailed,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              Text(
                isDone
                    ? S.of(context).youHaveSuccessfullyMadeOrder
                    : S.of(context).Pleasetryagain,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isDone) {
                        User? user = FirebaseAuth.instance.currentUser;
                        DocumentReference userRef = FirebaseFirestore.instance
                            .collection('tempUsers')
                            .doc(user!.uid);
                        DocumentSnapshot userSnapshot = await userRef.get();
                        if (userSnapshot.exists) {
                          Map<String, dynamic> userData =
                              userSnapshot.data() as Map<String, dynamic>;
                          if (userData['buyer'] == false) {
                            await userRef.update({'buyer': true});
                          }
                        }
                        Orders? order = await Provider.of<OrdersController>(
                                context,
                                listen: false)
                            .fetchMostRecentOrderByUserId(user.uid);

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => TrackOrderScreen(
                            order: order!,
                            isfromOrder: false,
                          ),
                        ));
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: defaultColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Text(
                        isDone ? S.of(context).trackOrder : S.of(context).Exit),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
