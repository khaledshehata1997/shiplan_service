import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shiplan_service/constant/counteries.dart';
import 'package:shiplan_service/view/home_view/buy_offers_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shiplan_service/view/view_mids_by_country.dart';

class CounteriesScreen extends StatelessWidget {
  bool isAdmin = false;
  CounteriesScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(title: const Text('الدول'), centerTitle: true),
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              itemCount: counteriesList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1.5, mainAxisSpacing: 5),
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
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              counteriesList[index].image,
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              counteriesList[index].name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              counteriesList[index].price,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )),
      ),
    );
  }
}
