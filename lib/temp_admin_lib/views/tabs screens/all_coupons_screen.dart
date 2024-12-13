import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_coupon_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_coupon_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/edit_coupon_screen.dart';

class AllCouponsScreen extends StatefulWidget {
  const AllCouponsScreen({super.key});

  @override
  State<AllCouponsScreen> createState() => _AllCouponsScreenState();
}

class _AllCouponsScreenState extends State<AllCouponsScreen> {
  List<GlobalKey> _dotKeys = [];
  @override
  void initState() {
    _dotKeys = List.generate(100, (index) => GlobalKey());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coupons',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (ctx) => const AddCouponScreen(),
                        ),
                      )
                          .then((_) async {
                        await Future.delayed(const Duration(seconds: 1));

                        setState(() {});
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      backgroundColor: defaultColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 10),
                        Text('Add New Coupon'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Consumer<AddCouponController>(
                builder: (context, couponProvider, _) {
                  couponProvider.fetchAllCoupons();
                  if (_dotKeys.length < couponProvider.coupons.length) {
                    _dotKeys = List.generate(couponProvider.coupons.length, (index) => GlobalKey());
                  }
                  return Column(
                    children: List.generate(
                      couponProvider.coupons.length,
                      (index) {
                        final startDate = couponProvider.coupons[index]['startDate']
                            as Timestamp; // Assuming it's a Firebase Timestamp
                        final formattedDate = DateFormat('yyyy-MM-dd').format(startDate.toDate());
                        final endDate = couponProvider.coupons[index]['endDate'] as Timestamp;
                        final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate.toDate());
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                    height: 250,
                                    width: 250,
                                    child: Image.asset('assets/coupon.png', color: defaultColor)),
                                Positioned(
                                  top: 65,
                                  left: 65,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'name: ${couponProvider.coupons[index]['name']}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'number of uses: ${couponProvider.coupons[index]['numberOfUse'].toString()}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'begin at: $formattedDate',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'end at: $formattedEndDate',
                                        style: const TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                                key: _dotKeys[index],
                                onTap: () async {
                                  final RenderBox renderBox = _dotKeys[index]
                                      .currentContext!
                                      .findRenderObject() as RenderBox;
                                  final Offset position = renderBox.localToGlobal(Offset.zero);
                                  showMenu(
                                    context: context,
                                    color: Colors.white,
                                    position: RelativeRect.fromLTRB(
                                      position.dx,
                                      position.dy,
                                      MediaQuery.of(context).size.width - position.dx,
                                      MediaQuery.of(context).size.height - position.dy,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    items: [
                                      PopupMenuItem(
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) => EditCouponScreen(
                                                    couponId: couponProvider.coupons[index]['id'],
                                                    endDate: endDate,
                                                    startDate: startDate,
                                                    name: couponProvider.coupons[index]['name'],
                                                    numberOfUse: couponProvider.coupons[index]
                                                        ['numberOfUse'],
                                                    sale: couponProvider.coupons[index]['sale'],
                                                  ),
                                                ),
                                              )
                                                  .then((_) async {
                                                await Future.delayed(const Duration(seconds: 1));

                                                setState(() {});
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset('assets/Pencil.svg'),
                                                const SizedBox(width: 10),
                                                const Text('Edit'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          leading: SvgPicture.asset('assets/Trash.svg'),
                                          title: const Text('Delete'),
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      const Icon(Icons.info,
                                                          color:
                                                              defaultColor), // Icon for the dialog
                                                      const SizedBox(width: 8),
                                                      const Text('Delete Coupon'),
                                                      const Spacer(),
                                                      IconButton(
                                                        icon: const Icon(Icons.close),
                                                        onPressed: () =>
                                                            Navigator.of(context).pop(),
                                                      ),
                                                    ],
                                                  ),
                                                  content: const Text(
                                                      'Are you sure you want to delete this Coupon?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog without deleting
                                                      },
                                                      child: const Text('Cancel',
                                                          style: TextStyle(color: Colors.grey)),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: defaultColor,
                                                        foregroundColor: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        // Call the delete function
                                                        await Provider.of<AddCouponController>(
                                                          context,
                                                          listen: false,
                                                        ).deleteCoupon(
                                                            couponProvider.coupons[index]['id']);
                                                        setState(() {
                                                          couponProvider.coupons.removeAt(index);
                                                        });
                                                      },
                                                      child: const Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                child: SvgPicture.asset('assets/dots.svg'))
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
