import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/shipping_charge_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/top_snack_bar_notfi.dart';

class AddShippingCharge extends StatefulWidget {
  const AddShippingCharge({super.key, required this.value});
  final double value;

  @override
  State<AddShippingCharge> createState() => _AddShippingChargeState();
}

class _AddShippingChargeState extends State<AddShippingCharge> {
  bool isLoading = false;
  final _valueController = TextEditingController();
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
    if (widget.value != 0) {
      _valueController.text = widget.value.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shipping Charge',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('Enter Value')],
                    ),
                    TextField(
                      controller: _valueController,
                      decoration: inputDecoration('Enter the value'),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: !isLoading
                      ? () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (_valueController.text.trim().isNotEmpty) {
                            if (widget.value == 0) {
                              Provider.of<ShippingChargeControllerAdmin>(context, listen: false)
                                  .addShippingCharge(double.parse(_valueController.text));
                              showTopSnackBar(
                                context,
                                "shipping charge added!",
                                Icons.check_circle,
                                defaultColor,
                                const Duration(seconds: 4),
                              );
                              setState(() {
                                _valueController.clear();
                              });
                            } else {
                              Provider.of<ShippingChargeControllerAdmin>(context, listen: false)
                                  .editShippingCharge(double.parse(_valueController.text));
                            }
                          } else {
                            showTopSnackBar(
                              context,
                              "field is required",
                              Icons.warning,
                              defaultColor,
                              const Duration(seconds: 4),
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
