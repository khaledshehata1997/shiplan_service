import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shiplan_service/constants.dart';
import 'package:shiplan_service/view/home_view/confirm_order_view.dart';
import 'package:shiplan_service/view_model/service_model/service_model.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.serviceModel});
  final ServiceModel serviceModel;
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${widget.serviceModel.vistCount} زيارات ${widget.serviceModel.isDay ? 'صباحية' : 'مسائية'} ${widget.serviceModel.maidCountry}',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              Text(
                '${widget.serviceModel.vistCount} زيارات علي مدار الشهر',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.serviceModel.priceAfterTax} ريال',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 17),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'تفاصيل الباقة',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${widget.serviceModel.vistCount} زيارات علي مدار الشهر',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.check, size: 18),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${widget.serviceModel.maidCountry}",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.person_outline_outlined,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.serviceModel.isDay ? "صباحية" : "مسائية",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.watch_later_outlined, size: 18),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'الأيام المتاحه للحجز',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        'الأحد',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '03:00م-07:00م',
                        textDirection: TextDirection.rtl,
                        style:
                            TextStyle(fontSize: 12, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        'الأثنين',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '03:00م-07:00م',
                        textDirection: TextDirection.rtl,
                        style:
                            TextStyle(fontSize: 12, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        'الثلاثاء',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '03:00م-07:00م',
                        textDirection: TextDirection.rtl,
                        style:
                            TextStyle(fontSize: 12, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        'الأربعاء',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '03:00م-07:00م',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        'الخميس',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '03:00م-07:00م',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        'السبت',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '03:00م-07:00م',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: Get.height * 0.15,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: Get.height * 0.06,
                  width: Get.width * 0.9,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor),
                      onPressed: () {
                        Get.to(const ConfirmOrderView());
                      },
                      child: const Text(
                        "احجز الأن",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
