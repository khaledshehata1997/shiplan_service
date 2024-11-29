import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar_jwt/jaguar_jwt.dart';

class ZainCashController with ChangeNotifier {
  Future<String> initiateZainCashTransaction(double price) async {
    String serviceType = "ecommerce cart";
    String orderId = "Bill_${DateTime.now().millisecondsSinceEpoch}";
    String redirectionUrl = 'myapp://paymentResult';
    String walletPhoneNumber = "9647730399011";
    String secret =
        r"$2y$10$ejByIdmIjB55PxC2Dgb.I.WSBJC4dvInk8CxqZfFVIXGq4n6iXaHW";
    String merchantId = "6730aa40b58036f8fe6f1994";
    String language = "en";

    final claimSet = JwtClaim(
      issuer: walletPhoneNumber,
      subject: orderId,
      issuedAt: DateTime.now(),
      expiry: DateTime.now().add(const Duration(hours: 4)),
      otherClaims: {
        'amount': price,
        'serviceType': serviceType,
        'msisdn': walletPhoneNumber,
        'orderId': orderId,
        'redirectUrl': redirectionUrl,
      },
    );
    String token = issueJwtHS256(claimSet, secret);

    String tUrl = 'https://api.zaincash.iq/transaction/init';

    // String tUrl = 'https://test.zaincash.iq/transaction/init';

    String rUrl = 'https://api.zaincash.iq/transaction/pay?id=';

    // String rUrl = 'https://test.zaincash.iq/transaction/pay?id=';

    Map<String, String> dataToPost = {
      'token': token,
      'merchantId': merchantId,
      'lang': language,
    };

    try {
      final response = await http.post(
        Uri.parse(tUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: dataToPost,
      );
      print({response.body});
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        // Check if 'id' exists and is a string
        if (responseData.containsKey('id') && responseData['id'] is String) {
          String transactionId = responseData['id'];
          String newUrl = rUrl + transactionId;
          log("transaction id:  " + transactionId);
          return transactionId;
        } else {
          log('Error: "id" not found or is null in response data');
          throw Exception('Transaction ID is missing in response');
        }
      } else {
        log('Error: ${response.statusCode}');
        log('Response body: ${response.body}');
        throw Exception('Failed to initiate transaction');
      }
    } catch (e) {
      log('Exception caught: $e');
      throw Exception('Transaction initiation failed');
    }
  }
}
