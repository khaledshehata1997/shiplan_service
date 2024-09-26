import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shiplan_service/constants.dart';
import 'package:shiplan_service/main.dart';
import 'package:shiplan_service/view/home_view/add_maid.dart';
import 'package:shiplan_service/view/home_view/add_offers.dart';
import 'package:shiplan_service/view/home_view/add_service.dart';
import 'package:shiplan_service/view/home_view/buy_offers_view.dart';
import 'package:shiplan_service/view/home_view/offers_view.dart';
import 'package:shiplan_service/view/home_view/order_data_view.dart';
import 'package:shiplan_service/view/home_view/order_details.dart';
import 'package:shiplan_service/view/home_view/orders_managment_view.dart';
import 'package:shiplan_service/view/home_view/rent_offers_view.dart';
import 'package:shiplan_service/view_model/service_model/service_model.dart';

// import '../drawer_screen/our_location_page.dart';
// import '../drawer_screen/technical_support.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        endDrawer: Drawer(
          backgroundColor: Colors.white,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(30),
                  width: Get.width,
                  height: Get.height * .2,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Image.asset('images/splash.png'),
                ),
                ListTile(
                  leading: const Icon(Icons.support_agent_outlined),
                  title: Text(
                    'الدعم الفني'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Get.to(const TechnicalSupport());
                  },
                ),
                ListTile(
                  // leading: const Icon(Icons.support_agent_outlined),
                  title: Text(
                    'اضافه خادمه'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Get.to(const AddMaidScreen());
                  },
                ),
                ListTile(
                  // leading: const Icon(Icons.support_agent_outlined),
                  title: Text(
                    'اضافه خدمه'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Get.to(const AddServiceScreen());
                  },
                ),
                ListTile(
                  // leading: const Icon(Icons.support_agent_outlined),
                  title: Text(
                    'اضافه عروض'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Get.to(const AddOffersScreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(
                    'اللغة'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Get.to(const Language());
                  },
                ),
                GestureDetector(
                  onTap: () {
                    // Get.to(const AboutUs());
                  },
                  child: ListTile(
                    leading: const Icon(Icons.group),
                    title: Text(
                      'من نحن'.tr,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.gps_fixed_outlined),
                  title: Text(
                    'موقعنا'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Get.to(const OurLocationPage());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: Row(
                    children: [
                      Text(
                        ' مشاركة التطبيق'.tr,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () async {
                    // Set the app link and the message to be shared
                    const String appLink =
                        'https://play.google.com/store/apps/details?id=com.example.myapp';
                    const String message =
                        'Share our app with others: $appLink';

                    // Share the app link and message using the share dialog
                    await FlutterShare.share(
                        title: 'مشاركة التطبيق',
                        text: message,
                        linkUrl: appLink);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.call),
                  title: Text(
                    'تواصل معنا'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.support),
                  title: Text(
                    'أداره الطلبات'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Get.to(const OrdersManagmentView());
                    // Get.to(const OurLocationPage());
                  },
                ),
                // FirebaseAuth.instance.currentUser == null
                //     ? GestureDetector(
                //   onTap: () {
                //     Get.to(const SignIn());
                //   },
                //   child: ListTile(
                //     title: Text(
                //       'تسجيل الدخول'.tr,
                //       style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: mainColor),
                //     ),
                //   ),
                // )
                //     :
                GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                        title: 'Are you sure?'.tr,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'no'.tr,
                                style: const TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, elevation: 10),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // auth.signOut();
                                // _handleSignOut();
                                // Get.offAll(const SignIn());
                              },
                              child: Text('yes'.tr,
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: mainColor, elevation: 10),
                            ),
                          ],
                        ));
                  },
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      'تسجيل الخروج'.tr,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(12),
              ),
              height: Get.height * 0.1,
              width: Get.width * 0.1,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                  )),
            ),
          ),
          centerTitle: true,
          title: Container(
              height: Get.height * .075,
              width: Get.width * .4,
              child: Image.asset('images/splash.png')),
          // title: const Text("الرئيسيه",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.black),),
          actions: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: Get.height * 0.1,
                width: Get.width * 0.135,
                child: IconButton(
                    onPressed: () {
                      _key.currentState!.openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.list_outlined,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              CarouselSlider(
                items: [
                  Container(
                    height: Get.height * .2,
                    width: Get.width * .8,
                    child: Image.asset(
                      'images/Frame 174.png',
                      width: Get.width,
                      // height: Get.height*.27,
                      scale: 1.2,
                    ),
                  ),
                  Container(
                    height: Get.height * .2,
                    width: Get.width * .8,
                    child: Image.asset(
                      'images/Frame 174.png',
                      width: Get.width,
                      // height: Get.height*.27,
                      scale: 1.2,
                    ),
                  ),
                  Container(
                    height: Get.height * .2,
                    width: Get.width * .8,
                    child: Image.asset(
                      'images/Frame 174.png',
                      width: Get.width,
                      // height: Get.height*.27,
                      scale: 1.2,
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 175,
                  aspectRatio: 16 / 10,
                  viewportFraction: .7,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(top: 10, right: 15),
                  child: const Text(
                    'الخدمات',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(const BuyOffersView());
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
                        Image.asset('images/pana.png'),
                        const Text(
                          'خدمه الأستقدام',
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
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(const RentOffersView());
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
                          'خدمه التأجير',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.to(const OffersView());
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      const Text(
                        'جميع العروض',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(right: 15),
                      child: const Text(
                        'العروض',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  height: Get.height * .3,
                  width: Get.width,
                  child: GridView.builder(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    //  physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
                            mainAxisSpacing: 15,
                            crossAxisCount: 1),
                    itemBuilder: (BuildContext context, int index) {
                      //  final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: () {
                            // Get.to(const ProductDetails());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            // height: Get.height * 0.09,
                            // width: Get.width * 0.4,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'images/women.png',
                                  ),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 3.0,
                                  ),
                                ],
                                color: index.isEven ? buttonColor : mainColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '4 زيارات مسائيه افريقيا',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '4 زيارات خلال الشهر',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.nights_stay_outlined),
                                      Text(
                                        'مسائي',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '310 ريال',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ));
  }
}
