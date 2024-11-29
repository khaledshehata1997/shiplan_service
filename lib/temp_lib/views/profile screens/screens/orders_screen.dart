import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/oreders_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/models/orders.dart';
import 'package:shiplan_service/temp_lib/views/payment%20screens/track_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final AuthService authService;
  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        appBar: AppBar(
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          title: Text(S.of(context).orders,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: authService.user != null
            ? FutureBuilder<List<Orders>>(
                future: Provider.of<OrdersController>(context, listen: false)
                    .fetchOrdersByUserId(authService.user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    var orders = snapshot.data;
                    return SingleChildScrollView(
                      child: Column(
                          children: List.generate(
                        orders!.length,
                        (index) {
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
                                  orders[index].id,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                /////////////////////////////////////////
                                for (int i = 0;
                                    i < orders[index].productPrice.length;
                                    i++) ...[
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 85,
                                          width: 85,
                                          child: Image.memory(base64Decode(
                                              orders[index].image[i]))),
                                      Text(
                                        orders[index].productName[i].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
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
                                      Text(
                                        S.of(context).qty,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(orders[index].qty[i].toString()),
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
                                      Text(
                                        S.of(context).price,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(orders[index]
                                          .productPrice[i]
                                          .toString()),
                                    ],
                                  ),
                                ],
                                const SizedBox(
                                  height: 15,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          S.of(context).total,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(orders[index]
                                            .totalPrice
                                            .toString()),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    TrackOrderScreen(
                                                      order: orders[index],
                                                      isfromOrder: true,
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: defaultColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          )),
                                      child: orders[index].status !=
                                              S.of(context).Completed
                                          ? orders[index].status ==
                                                  S.of(context).refunded
                                              ? Text(S.of(context).refunded)
                                              : Text(S.of(context).trackOrder)
                                          : Text(S.of(context).Completed),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                    );
                  } else {
                    return Center(child: Text(S.of(context).noOrdersAvailable));
                  }
                },
              )
            : const Center(
                child: Text('Login to See Orders'),
              ));
  }
}
