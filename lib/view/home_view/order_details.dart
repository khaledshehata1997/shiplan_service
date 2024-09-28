import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${widget.serviceModel.vistCount} زيارات ${widget.serviceModel.isDay ? 'صباحية' : 'مسائية'} ${widget.serviceModel.maidCountry}',
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Text(
                '${widget.serviceModel.vistCount} زيارات علي مدار الشهر',
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.serviceModel.regularPrice} ريال',
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 17),
              ),
               const SizedBox(height: 10),
                  Text(
                'السعر بعد الضريبة ${widget.serviceModel.priceAfterTax} ريال',
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 17),
              ),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'تفاصيل الباقة',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${widget.serviceModel.vistCount} زيارات علي مدار الشهر',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.check, size: 18),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.serviceModel.maidCountry,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.person_outline_outlined,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.serviceModel.isDay ? "صباحية" : "مسائية",
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.watch_later_outlined, size: 18),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'الأيام المتاحة للحجز',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Dynamic display of the available days and time ranges
              _buildAvailableDays(widget.serviceModel.freeDays ),

              const Divider(),
              SizedBox(height: Get.height * 0.15),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: Get.height * 0.06,
                  width: Get.width * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    onPressed: () {
                      Get.to( ConfirmOrderView(serviceModel: widget.serviceModel));
                    },
                    child: const Text(
                      "احجز الأن",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to dynamically build the available days and their time ranges
  Widget _buildAvailableDays(Map<String, Map<String, String>> freeDays) {
    if (freeDays.isEmpty) {
      return const Text(
        'لا يوجد أيام متاحة',
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 16, color: Colors.red),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: freeDays.entries.map((entry) {
        final day = entry.key;
        final startTime = entry.value['startTime'] ?? 'N/A';
        final endTime = entry.value['endTime'] ?? 'N/A';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    day,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '$startTime - $endTime',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.blueAccent),
                  ),
                ],
              ),
              const SizedBox(width: 30),
            ],
          ),
        );
      }).toList(),
    );
  }
}
