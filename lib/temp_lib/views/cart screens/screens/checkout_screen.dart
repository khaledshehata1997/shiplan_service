// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/widgets/cart_item.dart';
import 'package:shiplan_service/temp_lib/views/payment%20screens/screens/payment_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/best_seller_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key,
      required this.selectedItems,
      required this.products,
      required this.itemTotal,
      required this.total,
      required this.couponSale,
      required this.shippingCharge});
  final int selectedItems;
  final List<Product> products;
  final double itemTotal;
  final double total;
  final double couponSale;
  final double shippingCharge;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAddress = 0;
  List<String> addresses = [];
  int _selectedPhoneNumber = 0; // New
  List<String> phoneNumbers = []; // New
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _addAddress() async {
    try {
      if (_addressController.text.isNotEmpty) {
        String newAddress = _addressController.text;
        setState(() {
          addresses.add(newAddress);
          _addressController.clear();
        });
        String userId = FirebaseAuth.instance.currentUser!.uid;
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('tempUsers').doc(userId);
        DocumentSnapshot userSnapshot = await userRef.get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          List<dynamic> existingAddresses = userData['addresses'] ?? [];
          existingAddresses.add(newAddress);
          await userRef.update({
            'addresses': existingAddresses,
          });
        } else {
          await userRef.set({
            'addresses': [newAddress],
          });
        }
      }
    } catch (e) {
      log("Failed to add address: $e");
    }
  }

  void _addPhoneNumber() async {
    // New method for adding phone number
    try {
      if (_phoneNumberController.text.length != 11) {
        showTopSnackBar(
          context,
          S.of(context).phone_number_is_not_valid,
          Icons.info,
          defaultColor,
          const Duration(seconds: 4),
        );
        return;
      }
      if (_phoneNumberController.text.isNotEmpty) {
        String newPhoneNumber = _phoneNumberController.text;
        setState(() {
          phoneNumbers.add(newPhoneNumber);
          _phoneNumberController.clear();
        });
        String userId = FirebaseAuth.instance.currentUser!.uid;
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('tempUsers').doc(userId);
        DocumentSnapshot userSnapshot = await userRef.get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          List<dynamic> existingPhoneNumbers = userData['phoneNumbers'] ?? [];
          existingPhoneNumbers.add(newPhoneNumber);
          await userRef.update({
            'phoneNumbers': existingPhoneNumbers,
          });
        } else {
          await userRef.set({
            'phoneNumbers': [newPhoneNumber],
          });
        }
      }
    } catch (e) {
      log("Failed to add phone number: $e");
    }
  }

  void _fetchAddressesAndPhoneNumbers() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('tempUsers').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        if (userData.containsKey('addresses')) {
          List<dynamic> fetchedAddresses = userData['addresses'];
          setState(() {
            addresses = fetchedAddresses.cast<String>();
          });
        }

        if (userData.containsKey('phoneNumbers')) {
          // Fetch phone numbers
          List<dynamic> fetchedPhoneNumbers = userData['phoneNumbers'];
          setState(() {
            phoneNumbers = fetchedPhoneNumbers.cast<String>();
          });
        }
      }
    } catch (e) {
      log("Failed to fetch addresses or phone numbers: $e");
    }
  }

  void _deleteAddress(String addressToDelete) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('tempUsers').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        List<dynamic> existingAddresses = userData['addresses'] ?? [];

        // Remove the selected address
        existingAddresses.remove(addressToDelete);

        // Update Firestore
        await userRef.update({
          'addresses': existingAddresses,
        });

        // Update local state
        setState(() {
          addresses.remove(addressToDelete);
        });

        log("Address deleted successfully");
      }
    } catch (e) {
      log("Failed to delete address: $e");
    }
  }

  void _deletePhoneNumber(String phoneNumberToDelete) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('tempUsers').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        List<dynamic> existingPhoneNumbers = userData['phoneNumbers'] ?? [];

        // Remove the selected phone number
        existingPhoneNumbers.remove(phoneNumberToDelete);

        // Update Firestore
        await userRef.update({
          'phoneNumbers': existingPhoneNumbers,
        });

        // Update local state
        setState(() {
          phoneNumbers.remove(phoneNumberToDelete);
        });

        log("Phone number deleted successfully");
      }
    } catch (e) {
      log("Failed to delete phone number: $e");
    }
  }

  @override
  void initState() {
    _fetchAddressesAndPhoneNumbers(); // Fetch both at init
    super.initState();
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
            S.of(context).checkout,
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                  controller: _addressController,
                                  decoration: inputDecoration(
                                      S.of(context).enterYourAddress)),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _addAddress,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: inputDecoration(
                                      S.of(context).enterYourPhoneNumber)),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _addPhoneNumber,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(addresses.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                    SvgPicture.asset('assets/homeaddress.svg'),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RadioListTile(
                                  activeColor: defaultColor,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: index,
                                  groupValue: _selectedAddress,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _selectedAddress = value!;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: Text(
                                    '${S.of(context).address} ${index + 1}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    addresses[index],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(100, 116, 139, 1)),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _deleteAddress(addresses[index]);
                                  },
                                  child: const Icon(Icons.delete_outline)),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        );
                      }),
                      ...List.generate(phoneNumbers.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.phone),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RadioListTile(
                                  activeColor: defaultColor,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: index,
                                  groupValue: _selectedPhoneNumber,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _selectedPhoneNumber = value!;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: Text(
                                    '${S.of(context).phoneNumber} ${index + 1}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    phoneNumbers[index],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(100, 116, 139, 1)),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _deletePhoneNumber(phoneNumbers[index]);
                                  },
                                  child: const Icon(Icons.delete_outline)),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      ...List.generate(
                        widget.selectedItems,
                        (index) {
                          var product = widget.products[index];
                          return CartItem(
                            isCheckout: true,
                            product: product,
                            onDelete: () {},
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          S.of(context).priceDetails,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).itemTotal,
                                style: const TextStyle(fontSize: 16)),
                            Text('${widget.itemTotal} IQD',
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      widget.couponSale != 0
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
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).shippingCharge,
                                style: const TextStyle(fontSize: 16)),
                            Text('${widget.shippingCharge} IQD',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).total,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${(widget.total)} IQD',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (addresses.isEmpty || phoneNumbers.isEmpty) {
                    showTopSnackBar(
                      context,
                      S.of(context).address_and_phone_number_are_required,
                      Icons.check_circle,
                      defaultColor,
                      const Duration(seconds: 4),
                    );
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => PaymentScreen(
                        shippingCharge: widget.shippingCharge,
                        couponSale: widget.couponSale,
                        total: widget.total,
                        itemTotal: widget.itemTotal,
                        address: addresses[_selectedAddress],
                        phoneNumber: phoneNumbers[_selectedPhoneNumber],
                      ),
                    ));
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: defaultColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      S.of(context).porceedToBuy,
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
          ),
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
