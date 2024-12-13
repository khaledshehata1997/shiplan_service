import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/orders_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/no_data_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/completed_content.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/new_orders_content.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/no_content_widget.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/order_delivery_content.dart';

class OredersScreen extends StatelessWidget {
  const OredersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<OrdersControllerAdmin>(context, listen: false).fetchAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const NoDataScreen(title: 'Orders');
        } else {
          return DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Orders',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        labelPadding: EdgeInsets.zero, // No padding between label and indicator
                        indicator: BoxDecoration(
                          color: defaultColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: defaultColor,
                        tabs: const [
                          _CustomTab(text: 'New Orders'),
                          _CustomTab(text: 'On the Way'),
                          _CustomTab(text: 'Completed'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        Consumer<OrdersControllerAdmin>(
                          builder: (context, orderProvider, _) {
                            return FutureBuilder<List<Map<String, dynamic>>>(
                              future: orderProvider.fetchAllOrders(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasData) {
                                  final orders = snapshot.data!;
                                  final filteredOrders = orders
                                      .where(
                                        (e) =>
                                            e['status'] == 'Pending' || e['status'] == 'preparing',
                                      )
                                      .toList();
                                  if (filteredOrders.isEmpty) {
                                    return const Center(
                                      child: Text('No Orders here'),
                                    );
                                  } else {
                                    return SingleChildScrollView(
                                      child: Column(
                                          children: List.generate(
                                        filteredOrders.length,
                                        (index) {
                                          return NewOrdersContent(
                                            orderId: filteredOrders[index]['id'],
                                            image: filteredOrders[index]['image'],
                                            productName: filteredOrders[index]['productName'],
                                            qty: filteredOrders[index]['qty'],
                                            price: filteredOrders[index]['productPrice'],
                                            totalPrice: filteredOrders[index]['totalPrice'],
                                            status: filteredOrders[index]['status'],
                                            address: filteredOrders[index]['address'],
                                            phoneNumber: filteredOrders[index]['phoneNumber'],
                                            paymentType: filteredOrders[index]['paymentType'],
                                          );
                                        },
                                      )),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: Text('No Orders available'),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        Consumer<OrdersControllerAdmin>(
                          builder: (context, orderProvider, _) {
                            return FutureBuilder(
                              future: orderProvider.fetchAllOrders(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  final orders = snapshot.data!;
                                  final filteredOrders = orders
                                      .where(
                                        (e) => e['status'] == 'order delivery',
                                      )
                                      .toList();
                                  if (filteredOrders.isEmpty) {
                                    return const NoContentWidget();
                                  } else {
                                    return SingleChildScrollView(
                                      child: Column(
                                          children: List.generate(
                                        filteredOrders.length,
                                        (index) {
                                          return OrderDeliveryContent(
                                            userId: filteredOrders[index]['userId'],
                                            orderId: filteredOrders[index]['id'],
                                            image: filteredOrders[index]['image'],
                                            productName: filteredOrders[index]['productName'],
                                            qty: filteredOrders[index]['qty'],
                                            price: filteredOrders[index]['productPrice'],
                                            totalPrice: filteredOrders[index]['totalPrice'],
                                            status: filteredOrders[index]['status'],
                                            address: filteredOrders[index]['address'],
                                            phoneNumber: filteredOrders[index]['phoneNumber'],
                                            paymentType: filteredOrders[index]['paymentType'],
                                          );
                                        },
                                      )),
                                    );
                                  }
                                } else {
                                  return const NoContentWidget();
                                }
                              },
                            );
                          },
                        ),
                        Consumer<OrdersControllerAdmin>(
                          builder: (context, ordersProvider, _) {
                            return FutureBuilder(
                              future: ordersProvider.fetchAllOrders(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  final orders = snapshot.data!;
                                  final filteredOrders = orders
                                      .where(
                                        (e) => e['status'] == 'completed',
                                      )
                                      .toList();
                                  if (filteredOrders.isEmpty) {
                                    return const NoContentWidget();
                                  } else {
                                    return SingleChildScrollView(
                                      child: Column(
                                          children: List.generate(
                                        filteredOrders.length,
                                        (index) {
                                          return CompletedContent(
                                            orderId: filteredOrders[index]['id'],
                                            image: filteredOrders[index]['image'],
                                            productName: filteredOrders[index]['productName'],
                                            qty: filteredOrders[index]['qty'],
                                            price: filteredOrders[index]['productPrice'],
                                            totalPrice: filteredOrders[index]['totalPrice'],
                                            status: filteredOrders[index]['status'],
                                            address: filteredOrders[index]['address'],
                                            phoneNumber: filteredOrders[index]['phoneNumber'],
                                            paymentType: filteredOrders[index]['paymentType'],
                                          );
                                        },
                                      )),
                                    );
                                  }
                                } else {
                                  return const NoContentWidget();
                                }
                              },
                            );
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class _CustomTab extends StatelessWidget {
  final String text;

  const _CustomTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
