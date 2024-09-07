import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OrderDataView extends StatefulWidget {
  const OrderDataView({super.key});

  @override
  State<OrderDataView> createState() => _OrderDataViewState();
}

class _OrderDataViewState extends State<OrderDataView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "بيانات الطلب",
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               Text(
                'رقم الطلب',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
               SizedBox(
                height: 10,
              ),
               Text(
                'IWN216543',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
               SizedBox(
                height: 10,
              ),
               Divider(),
               SizedBox(
                height: 10,
              ),
               Text(
                'تفاصيل الطلب',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '3 زيارات علي مدار الشهر',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.check, size: 18),
                ],
              ),
               SizedBox(
                height: 5,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'اندونيسي',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
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
               SizedBox(
                width: 10,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'مسائية',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.watch_later_outlined, size: 18),
                ],
              ),
               SizedBox(
                height: 5,
              ),
               Divider(),
               SizedBox(
                height: 10,
              ),
               Text(
                'حاله الطلب',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
               SizedBox(
                height: 10,
              ),
               Text(
                'جاري',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
               SizedBox(
                height: 10,
              ),
               Divider(),
               SizedBox(
                height: 10,
              ),
               Text(
                'اسم العميل',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
               SizedBox(
                height: 10,
              ),
               Text(
                'احمد سعيد علي',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
               SizedBox(
                height: 10,
              ),
               Divider(),
               SizedBox(
                height: 10,
              ),
               Text(
                'العنوان',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
               SizedBox(
                height: 10,
              ),
               Text(
                '46 شارع 12 المساكن/الهرم',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
               SizedBox(
                height: 10,
              ),
               Divider(),
               SizedBox(
                height: 10,
              ),
               Text(
                'رقم الهاتف',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
               SizedBox(
                height: 10,
              ),
               Text(
                '01265486541',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
               SizedBox(
                height: 10,
              ),
               Divider(),
               SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
