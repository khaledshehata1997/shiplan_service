import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shiplan_service/view/home_view/order_data_view.dart';
import 'package:shiplan_service/view_model/maid_model/maid_model.dart';
import 'package:shiplan_service/view_model/service_model/service_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants.dart';

class ConfirmOrderView extends StatefulWidget {
  ServiceModel serviceModel;
   ConfirmOrderView({super.key, required this.serviceModel});

  @override
  State<ConfirmOrderView> createState() => _ConfirmOrderViewState();
}

class _ConfirmOrderViewState extends State<ConfirmOrderView> {
  List<MaidModel> _maids = [];
  MaidModel? _selectedMaid;
  String? _fullName;
  String? _phoneNumber;
  String? _address;
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadMaids();
  }

  Future<void> _loadMaids() async {
    List<MaidModel> fetchedMaids = await fetchMaids();
    setState(() {
      _maids = fetchedMaids;
    });
  }

  Future<List<MaidModel>> fetchMaids() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('maids')
          .doc('maidList')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic> maidServiceList =
            (snapshot.data() as Map<String, dynamic>)['maidService'] ?? [];

        List<MaidModel> maids = maidServiceList.map((maid) {
          return MaidModel(
            id: maid['id'] ?? "",
            name: maid['name'],
            age: maid['age'],
            country: maid['country'],
            imageUrl: maid['imageUrl'],
          );
        }).toList();

        return maids;
      } else {
        print('Document does not exist or has no maidServiceList');
        return [];
      }
    } catch (e) {
      print('Error fetching maids: $e');
      return [];
    }
  }

  Future<void> _confirmOrder() async {
    if (_selectedMaid == null ||
        _fullName == null ||
        _phoneNumber == null ||
        _address == null) {
      Get.snackbar('Error', 'Please fill all the fields and select a maid.');
      return;
    }

    try {
      // Create the order data
      Map<String, dynamic> orderData = {
        'maidId': _selectedMaid!.id,
        'maidName': _selectedMaid!.name,
        'fullName': _fullName,
        'phoneNumber': _phoneNumber,
        'price': widget.serviceModel.priceAfterTax,
        'serviceType': widget.serviceModel.isDay?'صباحية':'مسائية',
        'address': _address,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Reference to the user's document
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(_userId);

      // Get the current order history list from the user's document
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      Map<String, dynamic>? userData =
          userDocSnapshot.data() as Map<String, dynamic>?;

      // Initialize orderHistory if it doesn't exist
      List<dynamic> orderHistory = userData?['orderHistory'] ?? [];

      // Append the new order to the order history list
      orderHistory.add(orderData);

      // Update the user's document with the new order history list
      await userDocRef.update({'orderHistory': orderHistory});

      Get.snackbar('Success', 'Order confirmed and saved to history.');

      // WhatsApp URL with proper format
      String phoneNumber =
          "201064871625"; // Your custom phone number in international format (without the '+')
      String message = "Order Details:${widget.serviceModel.freeDays}  \n"
          "اسم الخادمة: ${_selectedMaid!.name}\n"
          "اسم العميل: $_fullName\n"
          "رقم الهاتف: $_phoneNumber\n"
          "العنوان: $_address\n"
          "السعر: ${widget.serviceModel.priceAfterTax}\n"
          "نوع الخدمة: ${widget.serviceModel.isDay?'صباحية':'مسائية'}\n"
          "التاريخ: ${DateTime.now().toIso8601String()}";

      String whatsappUrl =
          "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";

      // Launch WhatsApp with the new method
      Uri url = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar('Error', 'Could not launch WhatsApp.');
      }
    } catch (e) {
      print('Error saving order: $e');
      Get.snackbar('Error', 'Failed to confirm the order. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "تأكيد الحجز",
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * .02,
                ),
                _maids.isNotEmpty
                    ? DropdownButton<MaidModel>(
                        isExpanded: true,
                        itemHeight: 100,
                        hint: const Text('اختر الخادمة'),
                        value: _selectedMaid,
                        items: _maids.map((maid) {
                          return DropdownMenuItem<MaidModel>(
                            value: maid,
                            child: ListTile(
                              isThreeLine: true,
                              title: Text("الاسم: ${maid.name}"),
                              subtitle: Text("السن: ${maid.age}"),
                              leading: Image.network(maid.imageUrl),
                              trailing: Text("الدولة: ${maid.country}"),
                            ),
                          );
                        }).toList(),
                        onChanged: (MaidModel? newValue) {
                          setState(() {
                            _selectedMaid = newValue;
                          });
                        },
                      )
                    : const CircularProgressIndicator(),
                SizedBox(
                  height: Get.height * .04,
                ),
                TextFormField(
                  onChanged: (value) {
                    _fullName = value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.3),
                    filled: true,
                    labelText: 'الأسم كامل',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor, width: 2.0),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Get.height * .04,
                ),
                IntlPhoneField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.3),
                    filled: true,
                    labelText: 'رقم الهاتف',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor, width: 2.0),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  initialCountryCode: 'SA',
                  onChanged: (value) {
                    _phoneNumber = value.completeNumber;
                  },
                ),
                TextFormField(
                  onChanged: (value) {
                    _address = value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.3),
                    filled: true,
                    labelText: 'العنوان',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor, width: 2.0),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Get.height * .25,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: Get.height * 0.06,
                    width: Get.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor),
                      onPressed: _confirmOrder,
                      child: const Text(
                        "تأكيد الطلب",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
