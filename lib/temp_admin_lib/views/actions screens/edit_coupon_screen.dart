import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_coupon_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class EditCouponScreen extends StatefulWidget {
  const EditCouponScreen(
      {super.key,
      required this.name,
      required this.numberOfUse,
      required this.sale,
      required this.startDate,
      required this.endDate,
      required this.couponId});
  final String name;
  final int numberOfUse;
  final double sale;
  final Timestamp startDate;
  final Timestamp endDate;
  final String couponId;

  @override
  State<EditCouponScreen> createState() => _EditCouponScreenState();
}

class _EditCouponScreenState extends State<EditCouponScreen> {
  final _nameController = TextEditingController();
  final _numberOfUse = TextEditingController();
  final _saleController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool isLoading = false;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedStartDate) {
      setState(() {
        _selectedStartDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedEndDate) {
      setState(() {
        _selectedEndDate = pickedDate;
        // Calculate the duration in days
        // final int duration = pickedDate.difference(DateTime.now()).inDays;
      });
    }
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      labelText: labelText, // Dynamic labelText
      labelStyle: TextStyle(color: Colors.grey.shade400),
    );
  }

  @override
  void initState() {
    _nameController.text = widget.name;
    _saleController.text = widget.sale.toString();
    _numberOfUse.text = widget.numberOfUse.toString();
    _selectedEndDate = (widget.endDate).toDate();
    _selectedStartDate = (widget.startDate).toDate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Coupons',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Name'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: inputDecoration('Enter name'),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Number of use'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _numberOfUse,
                        decoration: inputDecoration('Enter number'),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Coupon Start'), // coupon start date.
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: AbsorbPointer(
                            child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: _selectedStartDate != null
                                  ? Text(
                                      'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedStartDate!)}',
                                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                                    )
                                  : const Text('Select Date')),
                        )),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Coupon end'), // coupon end date.
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => _selectEndDate(context),
                        child: AbsorbPointer(
                            child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: _selectedEndDate != null
                                  ? Text(
                                      'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedEndDate!)}',
                                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                                    )
                                  : const Text('Select Date')),
                        )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Coupon Sale'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _saleController,
                        decoration: inputDecoration('Enter the percentage'),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: !isLoading
                    ? () async {
                        if (_nameController.text.isEmpty ||
                            _saleController.text.isEmpty ||
                            _numberOfUse.text.isEmpty ||
                            _selectedStartDate == null ||
                            _selectedEndDate == null) {
                          showCustomNotification(context, 'Please fill in all fields');
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        final String nameEn = _nameController.text.trim();
                        final int numberOfUse = int.parse(_numberOfUse.text.trim());
                        final double sale = double.parse(_saleController.text.trim());
                        final DateTime startDate = _selectedStartDate!;
                        final DateTime endDate = _selectedEndDate!;
                        final int duration = endDate.difference(startDate).inDays;

                        // Accessing AddCouponController and calling editCoupon
                        await context.read<AddCouponController>().editCoupon(
                              context,
                              couponId: widget.couponId,
                              nameEn: nameEn,
                              duration: duration,
                              sale: sale,
                              numberOfUse: numberOfUse,
                              startDate: startDate,
                              endDate: endDate,
                            );

                        showTopSnackBar(
                          context,
                          "Coupon Updated!",
                          Icons.check_circle,
                          defaultColor,
                          const Duration(seconds: 4),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Update Coupon'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100.0,
        left: MediaQuery.of(context).size.width * 0.30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
