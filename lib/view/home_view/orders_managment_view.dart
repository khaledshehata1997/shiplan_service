import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shiplan_service/view/home_view/order_data_view.dart';

import '../../constants.dart';
class OrdersManagmentView extends StatefulWidget {
  const OrdersManagmentView({super.key});

  @override
  State<OrdersManagmentView> createState() => _OrdersManagmentViewState();
}

class _OrdersManagmentViewState extends State<OrdersManagmentView> {
  double value = 3.5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("اداره الطلبات",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.black),),
      ),
      body:  GridView.builder(
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
    );
  }
}
