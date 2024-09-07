import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants.dart';
import '../widgets/custom_text_form.dart';
class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("انشاء كلمة مرور جديده"),
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
                "يجب أن تكون كلمة المرور الجديده مختلفه عن كلمات المرور المستخدمة سابقا"),
          ),
          SizedBox(height: Get.height * 0.03),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: CustomTextForm(
                // controller: emailController,
                obsecure: true,
                decoration: InputDecoration(
                  suffixIcon:Icon(Icons.remove_red_eye_outlined),
                  fillColor: Colors.grey.withOpacity(0.3),
                  filled: true,
                  labelText: 'كلمة المرور الجديده'.tr,
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
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              textDirection: TextDirection.rtl,
              'يجب ان يكون علي الأقل 8 احرف',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: CustomTextForm(
                // controller: emailController,
                obsecure: true,
                decoration: InputDecoration(
                  suffixIcon:Icon(Icons.remove_red_eye_outlined),
                  fillColor: Colors.grey.withOpacity(0.3),
                  filled: true,
                  labelText: 'تأكيد كلمة المرور'.tr,
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
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              textDirection: TextDirection.rtl,
              'يجب ان تتطابق كلمتا المرور',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45
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
                    Get.defaultDialog(
                        backgroundColor: Colors.black45,
                        content: Container(
                          width: Get.width*.7,
                          height: Get.height*.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.done_outline,color: mainColor,size: 40,),
                              const Text(
                                textDirection: TextDirection.rtl,
                                'تم تحديث كلمة المرور الخاصه بك بنجاح',
                                style: TextStyle(
                                    fontSize: 22,

                                    color: Colors.white),
                              ),
                              // SizedBox(height: 40,),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }
                                  // setState(() {
                                  //   isloading = true;
                                  //   formKey.currentState!.save();
                                  //   if (formKey.currentState!.validate()) {
                                  //     controller.signIn();
                                  //     isloading = false;
                                  //   }
                                  //   isloading = false;
                                  // });
                                  ,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      fixedSize:
                                      Size.fromWidth(Get.width * .8)),
                                  child: const Text('عودة',style: TextStyle(color: Colors.white,fontSize: 18
                                      ,fontWeight: FontWeight.bold
                                  ),)),
                            ],
                          ),
                          //  color: Colors.black45,
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor),
                  child: Text(
                    "اعاده تعيين كلمه المرور",
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
