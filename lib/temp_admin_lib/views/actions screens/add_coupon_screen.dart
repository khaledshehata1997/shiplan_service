import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_coupon_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class AddCouponScreen extends StatefulWidget {
  const AddCouponScreen({super.key});

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final _nameController = TextEditingController();
  final _numberOfUse = TextEditingController();
  final _saleController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool isLoading = false;
  bool isCouponAdded = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Coupons',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(isCouponAdded);
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
                    ? () {
                        if (_selectedStartDate == null ||
                            _selectedStartDate == null ||
                            _numberOfUse.text.trim().isEmpty ||
                            _nameController.text.trim().isEmpty ||
                            _saleController.text.trim().isEmpty) {
                          showTopSnackBar(
                            context,
                            "all fields are required",
                            Icons.warning,
                            defaultColor,
                            const Duration(seconds: 4),
                          );
                        } else {
                          final couponDuration =
                              _selectedEndDate!.difference(_selectedStartDate!).inDays;
                          setState(() {
                            isLoading = true;
                          });
                          Provider.of<AddCouponController>(context, listen: false).addCoupon(
                            context,
                            duration: couponDuration,
                            nameEn: _nameController.text,
                            numberOfUse: int.parse(_numberOfUse.text),
                            sale: double.parse(_saleController.text),
                            endDate: _selectedEndDate!,
                            startDate: _selectedStartDate!,
                          );
                          setState(() {
                            isCouponAdded = true;
                            isLoading = false;
                            _nameController.clear();
                            _numberOfUse.clear();
                            _selectedStartDate = null;
                            _selectedEndDate = null;
                            _saleController.clear();
                          });
                          if (!Provider.of<AddCouponController>(context, listen: false)
                              .isNameAdded) {
                            showTopSnackBar(
                              context,
                              "coupon added",
                              Icons.check_circle,
                              defaultColor,
                              const Duration(seconds: 4),
                            );
                          } else {}
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Add Coupon'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
