import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/oreders_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/models/orders.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/tabs_screen.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen(
      {super.key, required this.order, required this.isfromOrder});
  final Orders order;
  final bool isfromOrder;

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  String orderId = '';
  String status = '';

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late String formattedDate;
  @override
  void initState() {
    status = widget.order.status;
    orderId = widget.order.id;
    formattedDate = formatter.format(DateTime.now());
    super.initState();
  }

  // Widget to build each timeline tile
  Widget _buildTimelineTile(BuildContext context,
      {required String icon,
      required String title,
      required String subtitle,
      required Color activeColor,
      required Color defaultColor,
      required bool isActive}) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color:
                isActive ? activeColor : defaultColor, // Active or non-active
          ),
          child: Center(
            child: SvgPicture.asset(icon),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Text(subtitle, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

// Main build method with updated logic
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    const defaultTileColor = Color.fromARGB(255, 232, 159, 173);
    const activeTileColor = Color.fromARGB(255, 239, 15, 89);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Navigate to home when back button is pressed
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (ctx) => const TabsScreen(isLoggedIn: true)),
        );
        return false; // prevent default pop behavior
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          appBar: AppBar(
            backgroundColor:
                themeProvider.isDarkMode ? darkMoodColor : Colors.white,
            title: Text(
              S.of(context).trackOrder,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (widget.isfromOrder) {
                  Navigator.pop(context);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const TabsScreen(isLoggedIn: true)));
                }
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${S.of(context).Order_Id}: $orderId',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        S.of(context).timeline,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      _buildTimelineTile(context,
                          activeColor: activeTileColor,
                          defaultColor: defaultTileColor,
                          icon: 'assets/accepted.svg',
                          title: S.of(context).packing,
                          subtitle: formattedDate,
                          isActive: status == 'Refunded' ? false : true),
                      _buildDottedLine(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimelineTile(
                            context,
                            activeColor: activeTileColor,
                            defaultColor: defaultTileColor,
                            icon: 'assets/packing-box-package_svgrepo.com.svg',
                            title: S.of(context).delivery,
                            subtitle: S.of(context).Your_order_is_on_his_way,
                            isActive: status == 'order delivery' ||
                                status == 'completed',
                          ),
                          status == 'order delivery'
                              ? ElevatedButton(
                                  onPressed: () {
                                    Provider.of<OrdersController>(context,
                                            listen: false)
                                        .updateOrderStatus(
                                            orderId, 'completed');
                                    setState(() {
                                      status = 'completed';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: defaultColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  child: Text('Complete'),
                                )
                              : SizedBox()
                        ],
                      ),
                      _buildDottedLine(),
                      _buildTimelineTile(
                        context,
                        activeColor: activeTileColor,
                        defaultColor: defaultTileColor,
                        icon: 'assets/deliverycar.svg',
                        title: S.of(context).Completed,
                        subtitle: S.of(context).Your_order_is_delivered,
                        isActive: status == 'completed',
                      ),
                      if (status == 'Refunded')
                        Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(S.of(context).thisorderisnotavailable),
                              ],
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const TabsScreen(isLoggedIn: true),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).Go_to_home,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: CustomPaint(
        size: const Size(1, 30), // width and height of the line
        painter: DottedLinePainter(),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var max = size.height;
    var dashHeight = 4;
    var dashSpace = 4;
    double startY = 0;

    while (startY < max) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
