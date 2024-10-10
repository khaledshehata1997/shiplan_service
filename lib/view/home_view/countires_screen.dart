import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shiplan_service/constant/counteries.dart';
import 'package:shiplan_service/constants.dart';
import 'package:shiplan_service/view/home_view/buy_offers_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shiplan_service/view/view_mids_by_country.dart';

class CounteriesScreen extends StatelessWidget {
  bool isAdmin = false;
  CounteriesScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green,
      appBar: AppBar(title: const Text('دول الاستقدام'), centerTitle: true),
      body: SafeArea(
        child: Center(
            child: Column(
              children: [
                Text(
                  '"جميع الاسعار شامله قيمة الضريبه المضافة"',
                  style: const TextStyle(

                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16

                  ),
                ),
                Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: Get.width,
                            height: Get.height*.78,
                            child: GridView.builder(
                                              itemCount: counteriesList.length,
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 1.1,
                                                mainAxisSpacing: 1,
                                              ),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: InkWell(
                                                    onTap: () {
                            Get.to(ViewMidsByCountery(
                              maidCountry: counteriesList[index].name,
                            ));
                                                    },
                                                    child: Container(
                            decoration: BoxDecoration(
                              color:mainColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 35,
                                      height: 35,
                                      child: SvgPicture.network(
                                        counteriesList[index].image,

                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      counteriesList[index].name,
                                      style: const TextStyle(

                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        fontSize: 18

                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text(
                                          "جديدة",
                                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          counteriesList[index].price,
                                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    if (counteriesList[index]
                                        .priceWithExtra
                                        .isNotEmpty)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            "سبق لها العمل",
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            counteriesList[index].priceWithExtra,
                                            style:
                                                const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                                                    ),
                                                  ),
                                                );
                                              }),
                          ),
                        ),
              ],
            )),
      ),
    );
  }
}
