import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shiplan_service/constants.dart';
import 'package:shiplan_service/view/home_view/order_details.dart';
import 'package:shiplan_service/view_model/service_model/service_model.dart';

class RentOffersView extends StatefulWidget {
  bool isAdmin;

  RentOffersView({super.key, required this.isAdmin});

  @override
  State<RentOffersView> createState() => _RentOffersViewState();
}

class _RentOffersViewState extends State<RentOffersView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  Future<List<ServiceModel>> fetchRentDayServices() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('rent').doc('day').get();

    if (snapshot.exists) {
      List<dynamic> servicesData =
          (snapshot.data() as Map<String, dynamic>)['rentService'] ?? [];
      return servicesData.map((data) => ServiceModel.fromMap(data)).toList();
    } else {
      return [];
    }
  }

  Future<void> deleteDayService(ServiceModel service) async {
    print("dddddffdfd ${widget.isAdmin}");

    try {
      await FirebaseFirestore.instance
          .collection('rent')
          .doc('day') // Specify the day or night document
          .update({
        'rentService': FieldValue.arrayRemove(
            [service.toMap()]) // Use the exact map from the object
      });
      Get.snackbar('Success', 'Service deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete service: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<List<ServiceModel>> fetchRentNightServices() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('rentOffers')
        .doc('night')
        .get();

    if (snapshot.exists) {
      List<dynamic> servicesData =
          (snapshot.data() as Map<String, dynamic>)['rentService'] ?? [];
      return servicesData.map((data) => ServiceModel.fromMap(data)).toList();
    } else {
      return [];
    }
  }

  Future<void> deleteRentNightService(ServiceModel service) async {
    try {
      await FirebaseFirestore.instance
          .collection('rentOffers')
          .doc('night') // Specify the day or night document
          .update({
        'rentService': FieldValue.arrayRemove(
            [service.toMap()]) // Use the exact map from the object
      });
      Get.snackbar('Success', 'Service deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete service: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    // tabController.addListener(() {
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "خدمات",
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
              child: TabBar(
                labelStyle: const TextStyle(fontSize: 20),
                indicatorColor: buttonColor,
                controller: tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: buttonColor,
                ),
                dividerColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  // first tab [you can add an icon using the icon property]
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: Tab(
                      text: 'مسائي',
                    ),
                  ),

                  // second tab [you can add an icon using the icon property]
                  SizedBox(
                    height: 45,
                    width: 300,
                    child: Tab(
                      text: 'صباحي',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(controller: tabController, children: [
                FutureBuilder<List<ServiceModel>>(
                  future: fetchRentNightServices(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No services found'));
                    } else {
                      List<ServiceModel> services = snapshot.data!;
                      return ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          ServiceModel service = services[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onLongPress: !widget.isAdmin
                                  ? () {}
                                  : () async {
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirm Delete'),
                                            content: const Text(
                                                'Are you sure you want to delete this service?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Delete'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirmDelete == true) {
                                        await deleteRentNightService(
                                            service); // Pass the full ServiceModel object
                                      }
                                    },
                              onTap: () {
                                Get.to(OrderDetails(
                                  serviceModel: service,
                                ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                // height: Get.height * 0.09,
                                // width: Get.width * 0.4,
                                decoration: BoxDecoration(
                                    // image: DecorationImage(
                                    //   scale: 1,
                                    //   alignment: Alignment.centerLeft,
                                    //   image: AssetImage(
                                    //     index.isOdd
                                    //         ? 'images/cleaning service.png'
                                    //         : 'images/man carrying son in baby sling.png',
                                    //   ),
                                    // ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    color:
                                        index.isEven ? buttonColor : mainColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        service.title,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'عدد الساعات: ${service.hours} ساعات',
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'السعر الأصلي: ${service.regularPrice} ريال',
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'السعر بعد الضريبة: ${service.priceAfterTax} ريال',
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                FutureBuilder<List<ServiceModel>>(
                  future: fetchRentDayServices(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No services found'));
                    } else {
                      List<ServiceModel> services = snapshot.data!;
                      return ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          ServiceModel service = services[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onLongPress: !widget.isAdmin
                                  ? () {}
                                  : () async {
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirm Delete'),
                                            content: const Text(
                                                'Are you sure you want to delete this service?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Delete'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirmDelete == true) {
                                        await deleteDayService(
                                            service); // Pass the full ServiceModel object
                                      }
                                    },
                              onTap: () {
                                Get.to(OrderDetails(
                                  serviceModel: service,
                                ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                // height: Get.height * 0.09,
                                // width: Get.width * 0.4,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      scale: 1,
                                      alignment: Alignment.centerLeft,
                                      image: AssetImage(
                                        index.isOdd
                                            ? 'images/cleaning service.png'
                                            : 'images/man carrying son in baby sling.png',
                                      ),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    color:
                                        index.isEven ? buttonColor : mainColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        service.title,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'عدد الساعات: ${service.hours} ساعات',
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'السعر الأصلي: ${service.regularPrice} ريال',
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'السعر بعد الضريبة: ${service.priceAfterTax} ريال',
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
