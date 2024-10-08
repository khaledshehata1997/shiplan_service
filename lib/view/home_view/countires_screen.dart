import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shiplan_service/constant/counteries.dart';
import 'package:shiplan_service/view/home_view/buy_offers_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CounteriesScreen extends StatelessWidget {
  bool isAdmin = false;
  CounteriesScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(title: const Text('Counteries')),
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
                      Get.to(BuyOffersView(isAdmin: isAdmin));
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              counteriesList[index].image,
                              width: 25,
                              height: 25,
                            ),
                            Text(counteriesList[index].name),
                            Text(counteriesList[index].price),
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
