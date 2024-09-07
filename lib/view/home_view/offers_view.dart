import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants.dart';
class OffersView extends StatefulWidget {
  const OffersView({super.key});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("العروض",textDirection: TextDirection.rtl,style: TextStyle(color: Colors.black),),
      ),
      body:
        Column(
          children: [
            const SizedBox(height: 15,),
            Expanded(
              child: GridView.builder(
                reverse: true,
                // scrollDirection: Axis.horizontal,
                //  physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .8,
                    mainAxisSpacing: 15,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  //  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                      onTap: (){
                        // Get.to(const ProductDetails());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        // height: Get.height * 0.09,
                        // width: Get.width * 0.4,
                        decoration: BoxDecoration(
                            image: const DecorationImage(image: AssetImage('images/women.png',),),
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
                              Text('4 زيارات مسائيه افريقيا',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text('4 زيارات خلال الشهر',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              SizedBox(height: 25,),
                              Divider(),
                              SizedBox(height: 25,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.nights_stay_outlined),
                                  Text('مسائي',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 15,),),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Text('310 ريال',textDirection:TextDirection.rtl,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}
