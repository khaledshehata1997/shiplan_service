import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/dashboard_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<DashboardController>(context, listen: false).getTotalBoughtProducts();
    Provider.of<DashboardController>(context, listen: false).getTotalRefundedProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (ZoomDrawer.of(context)!.isOpen()) {
                ZoomDrawer.of(context)!.close();
              } else {
                ZoomDrawer.of(context)!.open();
              }
            },
            icon: const Icon(Icons.menu)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                  width: 335,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      FutureBuilder(
                          future: Provider.of<DashboardController>(context, listen: false)
                              .getTotalSalesRevenue(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text('0');
                            } else if (snapshot.hasData) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'TOTAL SALES',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    snapshot.data!.toString(),
                                    style:
                                        const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_outward,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '0.4% ', // The first word
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'vs last month',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const Text('0');
                            }
                          }),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SvgPicture.asset('assets/upper rect.svg')),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SvgPicture.asset('assets/lower rect.svg')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                  width: 335,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TOTAL USERS',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<int>(
                            future: Provider.of<DashboardController>(context, listen: false)
                                .getTotalUsers(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.toString(),
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                                );
                              } else {
                                return const Text(
                                  '0',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_outward,
                                size: 20,
                                color: Colors.red,
                              ),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '0.4% ', // The first word
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'vs last month',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SvgPicture.asset('assets/upper rect.svg')),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SvgPicture.asset('assets/lower rect.svg')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                  width: 335,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TOTAL BUYERS',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<int>(
                            future: Provider.of<DashboardController>(context, listen: false)
                                .getTotalBuyers(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.toString(),
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                                );
                              } else {
                                return const Text(
                                  '0',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_outward,
                                size: 20,
                                color: Colors.red,
                              ),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '0.4% ', // The first word
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'vs last month',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SvgPicture.asset('assets/upper rect.svg')),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SvgPicture.asset('assets/lower rect.svg')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/Shape.svg'),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Product',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Consumer<DashboardController>(
                          builder: (context, value, _) {
                            if (value.productSold != 0) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    height: 125,
                                    width: 125,
                                    child: CircularProgressIndicator(
                                      value: (value.productSold /
                                          (value.productRefunded + value.productSold)),
                                      strokeCap: StrokeCap.round,
                                      color: defaultColor,
                                      backgroundColor: Colors.grey.shade300,
                                      strokeWidth: 10,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 18,
                                    left: 18,
                                    child: SizedBox(
                                      height: 89,
                                      width: 89,
                                      child: CircularProgressIndicator(
                                        value: (value.productRefunded /
                                            (value.productRefunded + value.productSold)),
                                        strokeCap: StrokeCap.round,
                                        color: const Color.fromRGBO(235, 126, 146, 0.4),
                                        backgroundColor: Colors.grey.shade300,
                                        strokeWidth: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Center(child: Text('No Progress'));
                            }
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('This Month',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                            const SizedBox(
                              width: 7,
                            ),
                            SvgPicture.asset('assets/arrow.svg'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color: defaultColor,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text('Product Sold',
                                style: TextStyle(color: defaultColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Consumer<DashboardController>(
                          builder: (context, dashBoard, _) {
                            return Text(dashBoard.productSold.toString(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                          },
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color: Color.fromRGBO(235, 126, 146, 0.4),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text('Product Return',
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Consumer<DashboardController>(
                          builder: (context, dashBoard, _) {
                            return Text(dashBoard.productRefunded.toString(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
