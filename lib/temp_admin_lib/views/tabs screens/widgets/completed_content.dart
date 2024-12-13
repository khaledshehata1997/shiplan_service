import 'dart:convert';

import 'package:flutter/material.dart';
class CompletedContent extends StatelessWidget {
  const CompletedContent({super.key, required this.orderId, required this.image, required this.productName, required this.qty, required this.price, required this.totalPrice, required this.status, required this.address, required this.phoneNumber,required this.paymentType});
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
          Text(orderId,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment type:'),
              Text(paymentType),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('address:'),
              Text(address),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('phone Number:'),
              Text(phoneNumber),
            ],
          ),
          /////////////////////////////////////////
        for(int i=0;i<price.length;i++)
          ...[
            Row(
            children: [
              SizedBox(
                height: 85,
                width: 85,
                child: Image.memory(base64Decode(image[i]))),
              Text(productName[i],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
          const SizedBox(height: 15,),
          Row(
            children: [
              const SizedBox(width: 15,),
              const Text('qty',style: TextStyle(color: Colors.grey,fontSize: 17),),
              const SizedBox(width: 10,),
              Text(qty[i].toString()),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const SizedBox(width: 15,),
              const Text('price',style: TextStyle(color: Colors.grey,fontSize: 17),),
              const SizedBox(width: 10,),
              Text(price[i].toString()),
            ],
          ),
          ],
          const SizedBox(height: 15,),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
            children: [
              const SizedBox(width: 15,),
              const Text('total',style: TextStyle(color: Colors.grey,fontSize: 17),),
              const SizedBox(width: 10,),
              Text(totalPrice.toString()),
            ],
          )
            ],
          ),
        ],
      ),
    );
  }
}