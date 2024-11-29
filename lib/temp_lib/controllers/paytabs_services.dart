// import 'dart:async';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
// import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
// import 'package:flutter_paytabs_bridge/PaymentSDKCardApproval.dart';
// import 'package:flutter_paytabs_bridge/PaymentSDKNetworks.dart';
// import 'package:flutter_paytabs_bridge/PaymentSDKQueryConfiguration.dart';
// import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
// import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
// import 'package:flutter_paytabs_bridge/PaymentSdkTransactionType.dart';
// import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
//
// class PaytabsServices with ChangeNotifier {
//   bool isDone = false;
//   static const String profileId = "152355";
//
//   static const String serverKey = "SMJ9WM92Z6-JJWWTZMDMT-LMDWNDMW2B";
//
//   static const String clientKey = "C9K2G2-MDQ266-VV79ND-BMK926";
//
//   static const String cartId = "12433";
//
//   static const String cartDescription = "makeup";
//
//   static const String merchantName = "kokohany";
//
//   static const String screenTitle = "Pay with Card";
//
//   static const double amount = 200.0;
//
//   static const String currencyCode = "IQD";
//
//   static const String merchantCountryCode = "IQ";
//
//   static const bool showBillingInfo = true;
//
//   static const bool forceShippingInfo = true;
//
//   static const tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
//
//   static const transactionType = PaymentSdkTransactionType.SALE;
//
//   final List<PaymentSDKNetworks> networks = [
//     PaymentSDKNetworks.visa,
//     PaymentSDKNetworks.amex,
//     PaymentSDKNetworks.masterCard,
//   ];
//
//   final PaymentSDKCardApproval cardApproval = PaymentSDKCardApproval(
//     validationUrl: "https://www.example.com/validation",
//     binLength: 6,
//     blockIfNoResponse: false,
//   );
//
//   static const String billingName = "kiro hany";
//
//   static const String billingEmail = "email@domain.com";
//
//   static const String billingPhone = "+97311111111";
//
//   static const String billingAddress = "st. 12";
//
//   static const String billingCountry = "IQ";
//
//   static const String billingCity = "dubai";
//
//   static const String billingState = "dubai";
//
//   static const String billingZipCode = "12345";
//
//   static const String shippingName = "John Smith";
//
//   static const String shippingEmail = billingEmail;
//
//   static const String shippingPhone = billingPhone;
//
//   static const String shippingAddress = billingAddress;
//
//   static const String shippingCountry = billingCountry;
//
//   static const String shippingCity = billingCity;
//
//   static const String shippingState = billingState;
//
//   static const String shippingZipCode = billingZipCode;
//   BillingDetails _createBillingDetails() {
//     return BillingDetails(
//       billingName,
//       billingEmail,
//       billingPhone,
//       billingAddress,
//       billingCountry,
//       billingCity,
//       billingState,
//       billingZipCode,
//     );
//   }
//
//   ShippingDetails _createShippingDetails() {
//     return ShippingDetails(
//       shippingName,
//       shippingEmail,
//       shippingPhone,
//       shippingAddress,
//       shippingCountry,
//       shippingCity,
//       shippingState,
//       shippingZipCode,
//     );
//   }
//
//
//   PaymentSdkConfigurationDetails _generatePaymentConfig() {
//     final configuration = PaymentSdkConfigurationDetails(
//       profileId: profileId,
//       serverKey: serverKey,
//       clientKey: clientKey,
//       transactionType: transactionType,
//       cartId: cartId,
//       cartDescription: cartDescription,
//       merchantName: merchantName,
//       screentTitle: screenTitle,
//       amount: amount,
//       showBillingInfo: showBillingInfo,
//       forceShippingInfo: forceShippingInfo,
//       currencyCode: currencyCode,
//       merchantCountryCode: merchantCountryCode,
//       billingDetails: _createBillingDetails(),
//       shippingDetails: _createShippingDetails(),
//       linkBillingNameWithCardHolderName: true,
//       cardApproval: cardApproval,
//     );
//
//     configuration.iOSThemeConfigurations = IOSThemeConfigurations();
//     configuration.tokeniseType = tokeniseType;
//
//     return configuration;
//   }
//
//
//   Future<void> handlePayment(Function paymentMethod) async {
//     Completer<void> completer = Completer<void>();
//     paymentMethod(_generatePaymentConfig(), (event) {
//       _processTransactionEvent(event);
//
//       if (event['status'] == 'success') {
//         isDone = true;
//       } else {
//         isDone = false;
//       }
//
//       completer.complete();
//       notifyListeners();
//     });
//
//     return completer.future;
//   }
//
//   void _processTransactionEvent(dynamic event) {
//     if (event["status"] == "success") {
//       final transactionDetails = event["data"];
//       _logTransaction(transactionDetails);
//     } else if (event["status"] == "error") {
//       log("Error occurred in transaction: ${event["message"]}");
//     } else if (event["status"] == "event") {
//       log("Event occurred: ${event["message"]}");
//     }
//   }
//
//   void _logTransaction(dynamic transactionDetails) {
//     if (transactionDetails["isSuccess"]) {
//       log("successful transaction");
//       isDone = true;
//       notifyListeners();
//       if (transactionDetails["isPending"]) {
//         log("transaction pending");
//       }
//     } else {
//       log(
//           "failed transaction. Reason: ${transactionDetails["payResponseReturn"]}");
//     }
//   }
//
//   PaymentSDKQueryConfiguration _generateQueryConfig() {
//     return PaymentSDKQueryConfiguration("ServerKey", "ClientKey",
//         "Country Iso 2", "Profile Id", "Transaction Reference");
//   }
//
//   Future<void> handleQuery() async {
//     FlutterPaytabsBridge.queryTransaction(
//       _generatePaymentConfig(),
//       _generateQueryConfig(),
//       (event) {
//           _processTransactionEvent(event);
//         notifyListeners();
//       },
//     );
//   }
//
//   List<Widget> buildPaymentButtons() {
//     return [
//       TextButton(
//         onPressed: () => handlePayment(FlutterPaytabsBridge.startCardPayment),
//         child: const Text('Pay with Card'),
//       ),
//       TextButton(
//         onPressed: () =>
//             handlePayment(FlutterPaytabsBridge.startPaymentWithSavedCards),
//         child: const Text('Pay with Saved Cards'),
//       ),
//     ];
//   }
// }
