import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../constants.dart';

class ConfirmOrderView extends StatefulWidget {
  const ConfirmOrderView({super.key});

  @override
  State<ConfirmOrderView> createState() => _ConfirmOrderViewState();
}

class _ConfirmOrderViewState extends State<ConfirmOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "تأكيد الحجز",
            textDirection: TextDirection.rtl,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * .02,
                  ),
                  TextFormField(

                    // controller: name,
                    onChanged: (value) {
                      // controller.name = value;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      labelText: 'الأسم كامل',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: Get.height * .04,
                  ),
                  IntlPhoneField(

                    // controller: phone,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      labelText: 'رقم الهاتف',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    initialCountryCode: 'SA',
                    onChanged: (value) {
                      // controller.phone = value.completeNumber;
                    },
                    validator: (value) {
                      if (value!.number.isEmpty) {
                        return 'Please enter phone';
                      }
                      // regx
                      const pattern =
                          r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
                      final regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value.number)) {
                        return 'Please enter valid phone';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // controller: name,
                    onChanged: (value) {
                      // controller.name = value;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      labelText: 'العنوان',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: Get.height * .04,
                  ),
                  TextFormField(
                    // controller: name,
                    onChanged: (value) {
                      // controller.name = value;
                    },
                    decoration: InputDecoration(fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      labelText: 'عدد الساعات',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: Get.height * .04,
                  ),
                  TextFormField(
                    // controller: name,
                    onChanged: (value) {
                      // controller.name = value;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      labelText: 'ميعاد الوصول',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.25,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: Get.height * 0.06,
                      width: Get.width * 0.9,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                          onPressed: (){},
                          child:const Text("تأكيد الطلب",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
