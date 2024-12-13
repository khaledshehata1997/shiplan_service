// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/notification_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/orders_controller.dart';

class NewOrdersContent extends StatefulWidget {
  const NewOrdersContent({
    super.key,
    required this.orderId,
    required this.image,
    required this.productName,
    required this.qty,
    required this.price,
    required this.totalPrice,
    required this.status,
    required this.address,
    required this.phoneNumber,
    required this.paymentType,
  });
  final String orderId;
  final List<String> image;
  final List<String> productName;
  final List<int> qty;
  final List<double> price;
  final double totalPrice;
  final String status;
  final String address;
  final String phoneNumber;
  final String paymentType;

  @override
  State<NewOrdersContent> createState() => _NewOrdersContentState();
}

class _NewOrdersContentState extends State<NewOrdersContent> {
  String status = '';

  @override
  void initState() {
    status = widget.status;
    Future.microtask(() {
      Provider.of<NotificationController>(context, listen: false).getAccessToken();
    });
    super.initState();
  }

  Future<void> _generateAndSharePdf() async {
    final pdf = pw.Document();

    // Load the Arabic font
    final arabicFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSansArabic_Condensed-Regular.ttf'));

    // Create PDF content
    pdf.addPage(
      pw.Page(
        textDirection: pw.TextDirection.rtl, // Set text direction to RTL for Arabic
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Shiblan',
                    style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('رقم الطلب: ',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold, font: arabicFont)),
                _dynamicText(widget.orderId, arabicFont),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                pw.Text('طريقة الدفع: ', style: pw.TextStyle(font: arabicFont)),
                _dynamicText(widget.paymentType, arabicFont),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('العنوان: ', style: pw.TextStyle(font: arabicFont)),
                _dynamicText(widget.address, arabicFont),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('رقم الهاتف: ', style: pw.TextStyle(font: arabicFont)),
                _dynamicText(widget.phoneNumber, arabicFont),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text('تفاصيل الطلب:',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: arabicFont)),
            ...List.generate(widget.productName.length, (index) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text('المنتج: ', style: pw.TextStyle(font: arabicFont)),
                      _dynamicText(widget.productName[index], arabicFont),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('الكمية: ', style: pw.TextStyle(font: arabicFont)),
                      _dynamicText(widget.qty[index].toString(), arabicFont),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('السعر: ', style: pw.TextStyle(font: arabicFont)),
                      _dynamicText(widget.price[index], arabicFont),
                      pw.Text(' دينار عراقي', style: pw.TextStyle(font: arabicFont)),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                ],
              );
            }),
            pw.Divider(),
            pw.Row(
              children: [
                pw.Text('السعر الإجمالي: ',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold, font: arabicFont)),
                _dynamicText(widget.totalPrice, arabicFont),
                pw.Text(' دينار عراقي', style: pw.TextStyle(font: arabicFont)),
              ],
            ),
          ],
        ),
      ),
    );

    // Save PDF to a temporary file
    final tempDir = await getTemporaryDirectory();
    final pdfFile = File('${tempDir.path}/order_${widget.orderId}.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Convert the File to XFile and share
    final xFile = XFile(pdfFile.path);
    await Share.shareXFiles([xFile], text: 'تفاصيل الطلب لرقم ${widget.orderId}');
  }

// Helper function to apply Arabic font conditionally
  pw.Widget _dynamicText(dynamic text, pw.Font arabicFont) {
    // Check if the text is in Arabic (basic check for Arabic characters)
    bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text.toString());
    if (text.toString() == "Cash On Delivery") {
      return pw.Text(
        "دفع عند التوصيل",
        style: pw.TextStyle(font: arabicFont),
      );
    } else if (text.toString() == "Zain Cash") {
      return pw.Text(
        "زين كاش",
        style: pw.TextStyle(font: arabicFont),
      );
    } else {
      return pw.Text(
        text.toString(),
        style: pw.TextStyle(font: isArabic ? arabicFont : null),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.orderId,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment type:'),
              Text(widget.paymentType),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Address:'),
              Text(widget.address),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Phone Number:'),
              Text(widget.phoneNumber),
            ],
          ),
          // Products list
          for (int i = 0; i < widget.price.length; i++) ...[
            Row(
              children: [
                SizedBox(
                  height: 85,
                  width: 85,
                  child: Image.memory(base64Decode(widget.image[i])),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.productName[i],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(width: 15),
                const Text(
                  'Qty',
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                const SizedBox(width: 10),
                Text(widget.qty[i].toString()),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 15),
                const Text(
                  'Price',
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                const SizedBox(width: 10),
                Text(widget.price[i].toString()),
              ],
            ),
          ],
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 15),
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.totalPrice.toString()),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (status == 'Pending') {
                    await Provider.of<OrdersControllerAdmin>(context, listen: false)
                        .updateOrderStatus(widget.orderId, 'preparing');
                    _generateAndSharePdf();
                    if (mounted) {
                      setState(() {
                        status = 'preparing';
                      });
                    }
                  } else if (status == 'preparing') {
                    final notfiProvider =
                        Provider.of<OrdersControllerAdmin>(context, listen: false);
                    await notfiProvider.updateOrderStatus(widget.orderId, 'order delivery');
                    Provider.of<NotificationController>(context, listen: false)
                        .sendNotificationToUser(
                      message: 'Your order is on its way now! (الطلب في طريقه اليك)',
                      title: 'Order Delivery (الطلب قيد التوصيل)',
                      userId: await notfiProvider.fetchUserIdByOrderId(widget.orderId),
                    );

                    if (mounted) {
                      setState(() {
                        status = 'order delivery';
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: status == 'Pending'
                    ? const Text('Prepare Order')
                    : const Text('Order Delivery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
