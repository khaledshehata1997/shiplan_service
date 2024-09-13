import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants.dart';
import '../widgets/custom_text_form.dart';
import 'reset_password.dart';
class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تغيير كلمة المرور"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
                "ادخل البريد الألكتروني المرتبط بحسابك وسنرسل أليك بريدا\n"
                " الكترونيا يحتوي علي تعليمات لاعاده تعيين كلمة المرور الخاصه\n بك."),
          ),
          SizedBox(height: Get.height * 0.03),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textDirection: TextDirection.rtl,
              'البريد الألكتروني',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.01),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: CustomTextForm(
                // controller: emailController,
                obsecure: false,
                decoration: InputDecoration(
                  fillColor: Colors.grey.withOpacity(0.3),
                  filled: true,
                  labelText: 'ehab@gmail.com'.tr,
                  border:  OutlineInputBorder(
                     borderSide: BorderSide.none,
                    borderRadius:
                    BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                // validate: (p0) {
                //   if (p0!.isEmpty) {
                //     return 'email is required'.tr;
                //   } else if (!p0.contains('@')) {
                //     return 'email must be valid'.tr;
                //   }
                //
                //   return null;
                // },
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.08),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: Get.height * 0.06,
                width: Get.width * .8,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(const ResetPass());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor),
                  child: Text(
                    "ارسال",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
