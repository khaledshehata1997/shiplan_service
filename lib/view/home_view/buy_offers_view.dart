import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shiplan_service/constants.dart';
import 'package:shiplan_service/view/home_view/order_details.dart';
class BuyOffersView extends StatefulWidget {
  const BuyOffersView({super.key});

  @override
  State<BuyOffersView> createState() => _BuyOffersViewState();
}

class _BuyOffersViewState extends State<BuyOffersView> with SingleTickerProviderStateMixin{
  late TabController tabController;
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
        title: const Text("خدمات الأستقدام",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.black),),
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
                  borderRadius: BorderRadius.all(Radius.circular(15)),
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
              child: TabBarView(
                controller: tabController,
                children: [
                  // first tab bar view widget
                  GridView.builder(
                    // scrollDirection: Axis.horizontal,
                    //  physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.9,
                        mainAxisSpacing: 15,
                        crossAxisCount: 1),
                    itemBuilder: (BuildContext context, int index) {
                      //  final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(const OrderDetails());
                            // Get.to(const ProductDetails());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            // height: Get.height * 0.09,
                            // width: Get.width * 0.4,
                            decoration: BoxDecoration(
                                image:  DecorationImage(
                                  scale: 0.9,
                                  alignment: Alignment.centerLeft,
                                  image: AssetImage(index.isOdd ? 'images/cleaning service.png' : 'images/man carrying son in baby sling.png',),),
                                boxShadow:  const  [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 3.0,
                                  ),
                                ],
                                color: index.isEven ?  buttonColor : mainColor,
                                borderRadius:
                                BorderRadius.circular(10)),
                            child:  const Padding(
                              padding:  EdgeInsets.all(8.0),
                              child:   Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('باقة 1 عامله + 1 مباشرة 8 ساعات 540 \n ريال بعد الضريبة 585 ريال ',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('عدد الساعات: 8 ساعات',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text('السعر الأصلي: 540 ريال',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text('السعر بعد الضريبة: 585 ريال',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // second tab bar view widget
                  GridView.builder(
                    // scrollDirection: Axis.horizontal,
                    //  physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.9,
                        mainAxisSpacing: 15,
                        crossAxisCount: 1),
                    itemBuilder: (BuildContext context, int index) {
                      //  final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(const OrderDetails());
                            // Get.to(const ProductDetails());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            // height: Get.height * 0.09,
                            // width: Get.width * 0.4,
                            decoration: BoxDecoration(
                                image:  DecorationImage(
                                  scale: 0.9,
                                  alignment: Alignment.centerLeft,
                                  image: AssetImage(index.isOdd ? 'images/cleaning service.png' : 'images/man carrying son in baby sling.png',),),
                                boxShadow:  const  [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 3.0,
                                  ),
                                ],
                                color: index.isEven ?  buttonColor : mainColor,
                                borderRadius:
                                BorderRadius.circular(10)),
                            child:  const Padding(
                              padding:  EdgeInsets.all(8.0),
                              child:   Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('باقة 1 عامله + 1 مباشرة 8 ساعات 540 \n ريال بعد الضريبة 585 ريال ',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('عدد الساعات: 8 ساعات',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text('السعر الأصلي: 540 ريال',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text('السعر بعد الضريبة: 585 ريال',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
