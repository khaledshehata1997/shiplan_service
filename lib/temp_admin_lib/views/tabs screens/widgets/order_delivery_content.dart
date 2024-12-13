// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/orders_controller.dart';

class OrderDeliveryContent extends StatefulWidget {
  const OrderDeliveryContent(
      {super.key,
      required this.orderId,
      required this.image,
      required this.productName,
      required this.qty,
      required this.price,
      required this.totalPrice,
      required this.status,
      required this.address,
      required this.phoneNumber,
      required this.userId,
      required this.paymentType});
  final String orderId;
  final List<String> image;
  final List<String> productName;
  final List<int> qty;
  final List<double> price;
  final double totalPrice;
  final String status;
  final String address;
  final String phoneNumber;
  final String userId;
  final String paymentType;

  @override
  State<OrderDeliveryContent> createState() => _OrderDeliveryContentState();
}

class _OrderDeliveryContentState extends State<OrderDeliveryContent> {
  String status = '';
  @override
  void initState() {
    status = widget.status;
    super.initState();
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
              const Text('address:'),
              Text(widget.address),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('phone Number:'),
              Text(widget.phoneNumber),
            ],
          ),
          /////////////////////////////////////////
          for (int i = 0; i < widget.price.length; i++) ...[
            Row(
              children: [
                SizedBox(height: 85, width: 85, child: Image.memory(base64Decode(widget.image[i]))),
                Text(
                  widget.productName[i],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'qty',
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.qty[i].toString()),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'price',
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.price[i].toString()),
              ],
            ),
          ],
          const SizedBox(
            height: 15,
          ),

          Row(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    'total',
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.totalPrice.toString()),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (widget.status == 'order delivery') {
                    await Provider.of<OrdersControllerAdmin>(context, listen: false)
                        .updateOrderStatus(widget.orderId, 'returned');
                    setState(() {
                      status = 'returned';
                    });
                    Provider.of<OrdersControllerAdmin>(context, listen: false)
                        .refundOrder(widget.userId, widget.orderId, context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                child: const Text('Returned'),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (widget.status == 'order delivery') {
                    await Provider.of<OrdersControllerAdmin>(context, listen: false)
                        .updateOrderStatus(widget.orderId, 'completed');
                    setState(() {
                      status = 'completed';
                    });
                    Provider.of<OrdersControllerAdmin>(context, listen: false).fetchAllOrders();
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                child: const Text('complete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
