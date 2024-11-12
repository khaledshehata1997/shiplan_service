import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shiplan_service/constants.dart';
import 'package:shiplan_service/main.dart';
import 'package:shiplan_service/view/home_view/add_maid.dart';
import 'package:shiplan_service/view/home_view/add_offers.dart';
import 'package:shiplan_service/view/home_view/add_service.dart';
import 'package:shiplan_service/view/home_view/add_special_order.dart';
import 'package:shiplan_service/view/home_view/buy_offers_view.dart';
import 'package:shiplan_service/view/home_view/countires_screen.dart';
import 'package:shiplan_service/view/home_view/offers_view.dart';
import 'package:shiplan_service/view/home_view/order_data_view.dart';
import 'package:shiplan_service/view/home_view/order_details.dart';
import 'package:shiplan_service/view/home_view/orders_managment_view.dart';
import 'package:shiplan_service/view/home_view/rent_offers_view.dart';
import 'package:shiplan_service/view/view_model/user_model.dart';
import 'package:shiplan_service/view_model/service_model/service_model.dart';

import '../auth_view/sign_in_view.dart';
import '../drawer_screen/our_location_page.dart';
import '../drawer_screen/technical_support.dart';

// import '../drawer_screen/our_location_page.dart';
// import '../drawer_screen/technical_support.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Future<List<ServiceModel>> fetchdayOffers() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('offers').doc('day').get();

    if (snapshot.exists) {
      List<dynamic> servicesData =
          (snapshot.data() as Map<String, dynamic>)['offers'] ?? [];
      return servicesData.map((data) => ServiceModel.fromMap(data)).toList();
    } else {
      return [];
    }
  }

  Future<List<ServiceModel>> fetchNightOffers() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('offers')
        .doc('night')
        .get();

    if (snapshot.exists) {
      List<dynamic> servicesData =
          (snapshot.data() as Map<String, dynamic>)['services'] ?? [];
      return servicesData.map((data) => ServiceModel.fromMap(data)).toList();
    } else {
      return [];
    }
  }

  Future<List<ServiceModel>> fetchAllOffers() async {
    List<ServiceModel> offersList = [];
    List<ServiceModel> offersDayOffers = await fetchdayOffers();
    print("dssdsd ${offersDayOffers.length}");
    List<ServiceModel> offersNightList = await fetchNightOffers();
    print("dssdsd ${offersNightList.length}");

    offersList.addAll(offersDayOffers);
    offersList.addAll(offersNightList);
    offersList.shuffle();

    return offersList;
  }

  late Future<UserModel> _user;
  bool isAdmin = false;
  List<ServiceModel> offersList = [];
  @override
  void initState() {
    _user = UserService().getUserData(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        // endDrawer: FutureBuilder<UserModel>(
        //     future: _user,
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(child: CircularProgressIndicator());
        //       }
        //       if (snapshot.hasError) {
        //         return Text('Error: ${snapshot.error}');
        //       }
        //       if (snapshot.hasData) {
        //         UserModel user = snapshot.data!;
        //         isAdmin = user.isAdmin;
        //         return Drawer(
        //           backgroundColor: Colors.white,
        //           child: Directionality(
        //             textDirection: TextDirection.rtl,
        //             child: ListView(
        //               padding: EdgeInsets.zero,
        //               children: <Widget>[
        //                 Container(
        //                   padding: const EdgeInsets.all(30),
        //                   width: Get.width,
        //                   height: Get.height * .2,
        //                   alignment: Alignment.center,
        //                   color: Colors.white,
        //                   child: Image.asset('images/splash.png'),
        //                 ),
        //                 ListTile(
        //                   leading: const Icon(Icons.support_agent_outlined),
        //                   title: Text(
        //                     'الدعم الفني'.tr,
        //                     style: const TextStyle(
        //                         fontSize: 18, fontWeight: FontWeight.bold),
        //                   ),
        //                   onTap: () {
        //                     Get.to(const TechnicalSupport());
        //                   },
        //                 ),
        //                 if (user.isAdmin)
        //                   ListTile(
        //                     // leading: const Icon(Icons.support_agent_outlined),
        //                     title: Text(
        //                       'اضافه خادمه'.tr,
        //                       style: const TextStyle(
        //                           fontSize: 18, fontWeight: FontWeight.bold),
        //                     ),
        //                     onTap: () {
        //                       Get.to(const AddMaidScreen());
        //                     },
        //                   ),
        //                 if (user.isAdmin)
        //                   ListTile(
        //                     // leading: const Icon(Icons.support_agent_outlined),
        //                     title: Text(
        //                       'اضافه خدمه'.tr,
        //                       style: const TextStyle(
        //                           fontSize: 18, fontWeight: FontWeight.bold),
        //                     ),
        //                     onTap: () {
        //                       Get.to(const AddServiceScreen());
        //                     },
        //                   ),
        //                 // if (user.isAdmin)
        //                 ListTile(
        //                   // leading: const Icon(Icons.support_agent_outlined),
        //                   title: Text(
        //                     'ارسل طلبك الخاص'.tr,
        //                     style: const TextStyle(
        //                         fontSize: 18, fontWeight: FontWeight.bold),
        //                   ),
        //                   onTap: () {
        //                     Get.to(const AddSpecialOrder());
        //                   },
        //                 ),
        //
        //                 ListTile(
        //                   leading: const Icon(Icons.share),
        //                   title: Row(
        //                     children: [
        //                       Text(
        //                         ' مشاركة التطبيق'.tr,
        //                         style: const TextStyle(
        //                             fontSize: 18, fontWeight: FontWeight.bold),
        //                       ),
        //                     ],
        //                   ),
        //                   onTap: () async {
        //                     // Set the app link and the message to be shared
        //                     const String appLink =
        //                         'https://play.google.com/store/apps/details?id=com.kh20.shiplan';
        //                     const String message =
        //                         'Share our app with others: $appLink';
        //
        //                     // Share the app link and message using the share dialog
        //                     await FlutterShare.share(
        //                         title: 'مشاركة التطبيق',
        //                         text: message,
        //                         linkUrl: appLink);
        //                   },
        //                 ),
        //
        //                 if (user.isAdmin)
        //                   ListTile(
        //                     leading: const Icon(Icons.support),
        //                     title: Text(
        //                       'أداره الطلبات'.tr,
        //                       style: const TextStyle(
        //                           fontSize: 18, fontWeight: FontWeight.bold),
        //                     ),
        //                     onTap: () {
        //                       Get.to(const OrdersManagmentView());
        //                       // Get.to(const OurLocationPage());
        //                     },
        //                   ),
        //                 // FirebaseAuth.instance.currentUser == null
        //                 //     ? GestureDetector(
        //                 //   onTap: () {
        //                 //     Get.to(const SignIn());
        //                 //   },
        //                 //   child: ListTile(
        //                 //     title: Text(
        //                 //       'تسجيل الدخول'.tr,
        //                 //       style: TextStyle(
        //                 //           fontSize: 18,
        //                 //           fontWeight: FontWeight.bold,
        //                 //           color: mainColor),
        //                 //     ),
        //                 //   ),
        //                 // )
        //                 //     :
        //                 GestureDetector(
        //                   onTap: () {
        //                     Get.defaultDialog(
        //                         title: 'Are you sure?'.tr,
        //                         content: Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceAround,
        //                           children: [
        //                             ElevatedButton(
        //                               onPressed: () {
        //                                 Navigator.pop(context);
        //                               },
        //                               style: ElevatedButton.styleFrom(
        //                                   backgroundColor: Colors.white,
        //                                   elevation: 10),
        //                               child: Text(
        //                                 'no'.tr,
        //                                 style: const TextStyle(
        //                                     color: Colors.black),
        //                               ),
        //                             ),
        //                             ElevatedButton(
        //                               onPressed: () {
        //                                 // auth.signOut();
        //                                 // _handleSignOut();
        //                                  Get.offAll( SignIn());
        //                               },
        //                               style: ElevatedButton.styleFrom(
        //                                   backgroundColor: mainColor,
        //                                   elevation: 10),
        //                               child: Text('yes'.tr,
        //                                   style: const TextStyle(
        //                                       color: Colors.white)),
        //                             ),
        //                           ],
        //                         ));
        //                   },
        //                   child: ListTile(
        //                     leading: const Icon(
        //                       Icons.logout_outlined,
        //                       color: Colors.red,
        //                     ),
        //                     title: Text(
        //                       'تسجيل الخروج'.tr,
        //                       style: const TextStyle(
        //                           fontSize: 18,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.red),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         );
        //       }
        //
        //       return Container();
        //     }),
        // appBar: AppBar(
        //   // leading: Padding(
        //   //   padding: const EdgeInsets.all(4.0),
        //   //   child: Container(
        //   //     decoration: BoxDecoration(
        //   //       color: buttonColor,
        //   //       borderRadius: BorderRadius.circular(12),
        //   //     ),
        //   //     height: Get.height * 0.1,
        //   //     width: Get.width * 0.1,
        //   //     child: IconButton(
        //   //         onPressed: () {},
        //   //         icon: const Icon(
        //   //           Icons.notifications_none_rounded,
        //   //           color: Colors.white,
        //   //         )),
        //   //   ),
        //   // ),
        //   centerTitle: true,
        //   title: SizedBox(
        //       height: Get.height * .05,
        //       width: Get.width * .3,
        //       child: Image.asset('images/new_icon.png')),
        //   // title: const Text("الرئيسيه",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.black),),
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.all(4.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: buttonColor,
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         height: Get.height * 0.1,
        //         width: Get.width * 0.135,
        //         child: IconButton(
        //             onPressed: () {
        //               _key.currentState!.openEndDrawer();
        //             },
        //             icon: const Icon(
        //               Icons.list_outlined,
        //               color: Colors.white,
        //             )),
        //       ),
        //     ),
        //   ],
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              // CarouselSlider(
              //   items: [
              //     SizedBox(
              //       height: Get.height * .25,
              //       width: Get.width * .8,
              //       child: Image.asset(
              //         'images/Frame 174.png',
              //         width: Get.width,
              //         // height: Get.height*.27,
              //         scale: 1.2,
              //       ),
              //     ),
              //     SizedBox(
              //       height: Get.height * .25,
              //       width: Get.width * .8,
              //       child: Image.asset(
              //         'images/Frame 174.png',
              //         width: Get.width,
              //         // height: Get.height*.27,
              //         scale: 1.2,
              //       ),
              //     ),
              //     SizedBox(
              //       height: Get.height * .25,
              //       width: Get.width * .8,
              //       child: Image.asset(
              //         'images/Frame 174.png',
              //         width: Get.width,
              //         // height: Get.height*.27,
              //         scale: 1.2,
              //       ),
              //     ),
              //   ],
              //   options: CarouselOptions(
              //     height: 200,
              //     aspectRatio: 20 / 10,
              //     viewportFraction: .8,
              //     initialPage: 0,
              //     enableInfiniteScroll: true,
              //     reverse: false,
              //     autoPlay: true,
              //     autoPlayInterval: const Duration(seconds: 8),
              //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
              //     autoPlayCurve: Curves.fastOutSlowIn,
              //     enlargeCenterPage: true,
              //     enlargeFactor: 0.3,
              //     scrollDirection: Axis.horizontal,
              //   ),
              // ),
              Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(top: 10, right: 15),
                  child: const Text(
                    'الخدمات',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 60,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: GestureDetector(
              //     onTap: () {
              //       //   Get.to( BuyOffersView(isAdmin:isAdmin));
              //       Get.to(CounteriesScreen(
              //         isAdmin: isAdmin,
              //       ));
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.all(4),
              //       // height: Get.height * 0.09,
              //       // width: Get.width * 0.4,
              //       decoration: BoxDecoration(
              //           boxShadow: const [
              //             BoxShadow(
              //               color: Colors.grey,
              //               offset: Offset(0.0, 1.0), //(x,y)
              //               blurRadius: 3.0,
              //             ),
              //           ],
              //           color: buttonColor,
              //           borderRadius: BorderRadius.circular(10)),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           Image.asset('images/pana.png'),
              //           const Text(
              //             'خدمات الاستقدام',
              //             style: TextStyle(
              //                 fontSize: 25,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(RentOffersView(
                      isAdmin: isAdmin,
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    // height: Get.height * 0.09,
                    // width: Get.width * 0.4,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 3.0,
                          ),
                        ],
                        color: mainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('images/pana1.png'),
                        const Text(
                          // 'خدمات التأجير',
                          'خدمات',

                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_downward),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'في حالة لم تجد طلبك',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(AddSpecialOrder(
                        //isAdmin: isAdmin,
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    // height: Get.height * 0.09,
                    // width: Get.width * 0.4,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 3.0,
                          ),
                        ],
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('images/pana1.png'),
                        const Text(
                          'تقدم بطلبك الخاص',
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         IconButton(
              //             onPressed: () {
              //               Get.to(OffersView(
              //                 offers: offersList,
              //                 isAdmin: isAdmin,
              //               ));
              //             },
              //             icon: const Icon(Icons.arrow_back_ios)),
              //         const Text(
              //           'جميع العروض',
              //           style: TextStyle(
              //               fontSize: 17, fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              //     Container(
              //         alignment: Alignment.topRight,
              //         margin: const EdgeInsets.only(right: 15),
              //         child: const Text(
              //           'العروض',
              //           style: TextStyle(
              //               fontSize: 20, fontWeight: FontWeight.bold),
              //         )),
              //   ],
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // SizedBox(
              //     height: Get.height * .235,
              //     width: Get.width,
              //     child: FutureBuilder<List<ServiceModel>>(
              //         future: fetchAllOffers(),
              //         builder: (context, snapshot) {
              //           if (snapshot.connectionState ==
              //               ConnectionState.waiting) {
              //             return const Center(
              //                 child: CircularProgressIndicator());
              //           } else if (snapshot.hasError) {
              //             return Center(
              //                 child: Text('Error: ${snapshot.error}'));
              //           } else if (!snapshot.hasData ||
              //               snapshot.data!.isEmpty) {
              //             return const Center(child: Text('No services found'));
              //           } else {
              //             List<ServiceModel> offers = snapshot.data!;
              //             offersList = offers;
              //             return GridView.builder(
              //               reverse: true,
              //               scrollDirection: Axis.horizontal,
              //               //  physics: const NeverScrollableScrollPhysics(),
              //               itemCount: offers.length,
              //               shrinkWrap: true,
              //               gridDelegate:
              //                   const SliverGridDelegateWithFixedCrossAxisCount(
              //                       childAspectRatio: .85,
              //                       mainAxisSpacing: 15,
              //                       crossAxisCount: 1),
              //               itemBuilder: (BuildContext context, int index) {
              //                 ServiceModel offer = offers[index];
              //                 return Padding(
              //                   padding: const EdgeInsets.all(6.0),
              //                   child: GestureDetector(
              //                     onTap: () {
              //                       Get.to(OrderDetails(serviceModel: offer));
              //                     },
              //                     child: Container(
              //                       padding: const EdgeInsets.all(4),
              //                       // height: Get.height * 0.09,
              //                       // width: Get.width * 0.4,
              //                       decoration: BoxDecoration(
              //                           // image: const DecorationImage(
              //                           //   image: AssetImage(
              //                           //     'images/women.png',
              //                           //   ),
              //                           // ),
              //                           boxShadow: const [
              //                             BoxShadow(
              //                               color: Colors.grey,
              //                               offset: Offset(0.0, 1.0), //(x,y)
              //                               blurRadius: 3.0,
              //                             ),
              //                           ],
              //                           color: buttonColor,
              //                           borderRadius:
              //                               BorderRadius.circular(10)),
              //                       child: Padding(
              //                         padding: const EdgeInsets.all(8.0),
              //                         child: Column(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.end,
              //                           children: [
              //                             Text(
              //                               '${offer.vistCount} زيارات ${offer.isDay ? "صباحية" : "مسائية"} ${offer.maidCountry}',
              //                               textDirection: TextDirection.rtl,
              //                               style: const TextStyle(
              //                                   fontSize: 15,
              //                                   fontWeight: FontWeight.bold),
              //                             ),
              //                             const SizedBox(
              //                               height: 25,
              //                             ),
              //                             Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.end,
              //                               children: [
              //                                 const Icon(
              //                                     Icons.nights_stay_outlined),
              //                                 Text(
              //                                   offer.isDay
              //                                       ? 'صباحية'
              //                                       : 'مسائية',
              //                                   textDirection:
              //                                       TextDirection.rtl,
              //                                   style: const TextStyle(
              //                                     fontSize: 15,
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                             const SizedBox(
              //                               height: 10,
              //                             ),
              //                             Text(
              //                               '${offer.priceAfterTax} ريال',
              //                               textDirection: TextDirection.rtl,
              //                               style: const TextStyle(
              //                                   fontSize: 15,
              //                                   fontWeight: FontWeight.bold),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 );
              //               },
              //             );
              //           }
              //         })),
            ],
          ),
        ));
  }
}
