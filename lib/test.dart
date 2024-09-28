import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiplan_service/constants.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: Get.width,
            height: Get.height*.32,
            decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40,left: 10,right: 10,bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back),
                      Text('حسابي',style: TextStyle(fontSize: 20),),
                      Icon(Icons.settings),

                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('khaled Sallam',style: TextStyle(
                            fontSize: 17,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('+201064871625',style: TextStyle(
                            fontSize: 16,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        ElevatedButton(onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:buttonColor,
                              fixedSize: Size.fromWidth(180)
                            ),
                            
                            child: Text('Edit Profile',style: TextStyle(
                              color: Colors.white,
                                fontSize: 17,fontWeight: FontWeight.bold)))
                      ],
                    ),
                    CircleAvatar(
                      radius: 50,

                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            width: Get.width,
            height: Get.height*.23,
            
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 1,
                  color: Colors.grey
                )
              ]
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home)),
        BottomNavigationBarItem(icon: Icon(Icons.person)),
      ]),
    );
  }
}
