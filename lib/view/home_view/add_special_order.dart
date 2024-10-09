import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiplan_service/constant/const_data.dart';
import 'package:shiplan_service/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AddSpecialOrder extends StatefulWidget {
  const AddSpecialOrder({super.key});

  @override
  State<AddSpecialOrder> createState() => _AddSpecialOrderState();
}

class _AddSpecialOrderState extends State<AddSpecialOrder> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final midAddressController = TextEditingController();
  final midAgeController = TextEditingController();
  final jobController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    midAddressController.dispose();
    midAgeController.dispose();
    jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أضف طلب خاص')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(nameController, 'اسمك', 'من فضلك ادخل اسمك'),
                _buildTextField(
                    phoneController, 'رقم الهاتف', 'من فضلك ادخل رقم الهاتف',
                    isNumber: true),
                _buildTextField(
                    addressController, 'عنوانك', 'من فضلك ادخل العنوان'),
                const Divider(),
                const SizedBox(height: 20),
                _buildTextField(midAddressController, 'عنوان الخادمة',
                    'من فضلك ادخل التفاصيل'),
                _buildTextField(
                    midAgeController, 'سن الخادمة', 'من فضلك ادخل سن الخادمة',
                    isNumber: true),
                _buildTextField(
                    jobController, 'وظيفة الخادمة', 'من فضلك ادخل الوظيفة'),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendRequest();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('ادخل جميع البيانات'),
                        ));
                      }
                    },
                    child: const Text('ارسال طلب خاص',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String? validatorMessage,
      {bool isNumber = false}) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          validator: validatorMessage != null
              ? (value) => value?.isEmpty ?? true ? validatorMessage : null
              : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  sendRequest() async {
    String phoneNumber = ConstData.phoneNumberWhatsapp;
    String message = "تم استلام طلب خاص\n"
        "الاسم: ${nameController.text}\n"
        "رقم الهاتف: ${phoneController.text}\n"
        "العنوان: ${addressController.text}\n"
        "عنوان الخادمة: ${midAddressController.text}\n"
        "سن الخادمة: ${midAgeController.text}\n"
        "الوظيفة: ${jobController.text}\n"
        "تاريخ الطلب: ${DateTime.now().toIso8601String()}\n";

    String whatsappUrl =
        "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";

    // Launch WhatsApp with the new method
    Uri url = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar('Error', 'Could not launch WhatsApp.');
    }
  }
}
