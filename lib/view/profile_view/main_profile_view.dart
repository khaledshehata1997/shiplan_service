import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shiplan_service/constants.dart';
import 'package:shiplan_service/view/profile_view/profile_view.dart';

import '../home_view/order_data_view.dart';
class MainProfileView extends StatefulWidget {
  const MainProfileView({super.key});

  @override
  State<MainProfileView> createState() => _MainProfileViewState();
}

class _MainProfileViewState extends State<MainProfileView> {
  double value = 3.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, Get.height * .3),
          child: Stack(
            children: [
              AppBar(
                centerTitle: true,
                title: Text("حسابي"),
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios,color: Colors.black,))
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconButton(onPressed: (){}, icon: Icon(Icons.settings,color: Colors.black,))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Text(
                                  'ايهاب ابراهيم',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.person_outline_outlined,size: 18,),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Text(
                                  '0545687415',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.call,size: 18,),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ClipOval(
                          child: Container(
                            color: Colors.white, // Optional: Background color behind the image
                            width: 100, // Diameter of the circle
                            height: 100, // Diameter of the circle
                            child: Image.asset(
                              "images/pana.png", // Replace with your image path
                              fit: BoxFit.cover, // Ensures the image covers the circle
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        height: Get.height * 0.04,
                        width: Get.width * 0.6,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const ProfileView());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor),
                          child: Text(
                            "تعديل الملف الشخصي",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.02,
          ),
          Center(
            child: const  Text(
              'اخر التعاقدات',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Expanded(
            child: GridView.builder(
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
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(const OrderDataView());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      // height: Get.height * 0.09,
                      // width: Get.width * 0.4,
                      decoration: BoxDecoration(
                          boxShadow:  const  [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 3.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(10)),
                      child:   Padding(
                        padding:  EdgeInsets.all(8.0),
                        child:   Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingStars(
                                  axis: Axis.horizontal,
                                  value: value,
                                  onValueChanged: (v) {
                                    //
                                    setState(() {
                                      value = v;
                                    });
                                  },
                                  starCount: 5,
                                  starSize: 20,
                                  valueLabelColor: mainColor,
                                  valueLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  valueLabelRadius: 10,
                                  maxValue: 5,
                                  starSpacing: 5,
                                  maxValueVisibility: true,
                                  valueLabelVisibility: false,
                                  animationDuration: Duration(milliseconds: 1000),
                                  valueLabelPadding:
                                  const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                                  valueLabelMargin: const EdgeInsets.only(right: 8),
                                  starOffColor: const Color(0xffe7e8ea),
                                  starColor: mainColor,
                                  // angle: 12,
                                ),

                                Text('رقم الطلب: IWN216543',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: buttonColor),),
                              ],
                            ),
                            const  SizedBox(height: 10,),
                            Text('السعر النهائي: 18.5 ريال',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: buttonColor),),
                            const SizedBox(height: 10,),
                            Text('حاله العقد: تم الأنتهاء',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: buttonColor),),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.remove_red_eye_outlined,color: mainColor,),
                                Text('(تم 4 زيارة من 4 زيارة)',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: buttonColor),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
