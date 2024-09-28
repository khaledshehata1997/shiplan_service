import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../view_model/service_model/service_model.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final summaryController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController(text: '0');
  final serviceTypeController = TextEditingController();
  final maidCountryController = TextEditingController();
  final hoursController = TextEditingController();
  final visitCountController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceAfterTaxController = TextEditingController(text: '0');

  String? _selectedValue;
  bool _isLoading = false;
  String _error = '';
  final List<String> listOfValue = ['أستقدام', 'تأجير'];

  // Multi-selection for weekdays and time range
  final List<String> _weekdays = ['السبت', 'الأحد', 'الأثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعه'];
  final Map<String, TimeRange> _selectedDays = {};

 void _submitService(bool isDay) async {
  if (_formKey.currentState?.validate() ?? false) {
    setState(() => _isLoading = true);

    try {
      // Prepare the freeDays data from the selected days and time ranges
      final Map<String, Map<String, String>> freeDays = _selectedDays.map((day, timeRange) {
        return MapEntry(
          day,
          {
            'startTime': timeRange.startTime?.format(context) ?? 'N/A',
            'endTime': timeRange.endTime?.format(context) ?? 'N/A',
          },
        );
      });

      final serviceModel = ServiceModel(
        maidId: "1",
        hours: int.parse(hoursController.text),
        vistCount: int.parse(visitCountController.text),
        serviceSummary: summaryController.text,
        isDay: isDay,
        maidCountry: maidCountryController.text,
        serviceType: serviceTypeController.text,
        description: descriptionController.text,
        freeDays: freeDays, // Assign the freeDays map here
        title: titleController.text,
        id: Uuid().v4(),
        regularPrice: double.parse(priceController.text),
        priceAfterTax: double.parse(priceAfterTaxController.text),
      );

      // Submit the service depending on the type
      if (_selectedValue == 'أستقدام') {
        isDay ? ServicesService.addDayService(serviceModel) : ServicesService.addNightService(serviceModel);
      } else {
        isDay ? ServicesService.addRentDayService(serviceModel) : ServicesService.addRentNightService(serviceModel);
      }

      // Log the selected days and time ranges for debugging
      print('Selected Free Days: $freeDays');

      // Handle success
      Get.back();
      Get.snackbar('Success', 'Service added successfully');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
@override
  void dispose() {
   summaryController.dispose();
   titleController.dispose();
   priceController.dispose();
   serviceTypeController.dispose();
   maidCountryController.dispose();
   hoursController.dispose();
   visitCountController.dispose();
   descriptionController.dispose();
   priceAfterTaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اضف خدمة")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                DropdownButtonFormField(
                  value: _selectedValue,
                  hint: Text(
                    'اختر نوع الخدمة',
                  ),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "can't empty";
                    } else {
                      return null;
                    }
                  },
                  items: listOfValue.map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
              _buildTextField(summaryController, 'تفصيل الخدمة', 'من فضلك اكتب تفاصيل الخدمة'),
              _buildTextField(titleController, 'العنوان', 'من فضلك اكتب عنوان الخدمة'),
              _buildTextField(serviceTypeController, 'نوع الخدمة', 'من فضلك اكتب نوع الخدمة'),
              _buildTextField(maidCountryController, 'دولة الخادمة', 'من فضلك اكتب دولة الخادمة'),
              _buildTextField(hoursController, 'عدد الساعات', null, isNumber: true),
              _buildTextField(visitCountController, 'عدد الزيارات', null, isNumber: true),
              _buildTextField(priceController, 'السعر', 'من فضلك اكتب السعر', isNumber: true),
              _buildTextField(priceAfterTaxController, 'سعر الخدمة بعد الضريبة', null, isNumber: true),              
              const SizedBox(height: 20),

              // Weekday multi-selection with time range
              _buildMultiSelectWeekdays(),
              const SizedBox(height: 20),
              _buildSelectedDaysTimeRange(),
              
              const SizedBox(height: 20),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSubmitButton('أضف خدمة صباحية', true),
                    _buildSubmitButton('أضف خدمة مسائية', false),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to show the multi-selection of weekdays
  Widget _buildMultiSelectWeekdays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Available Days', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: _weekdays.map((day) {
            return ChoiceChip(
              label: Text(day),
              selected: _selectedDays.containsKey(day),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDays[day] = TimeRange(); // Initialize with empty time range
                  } else {
                    _selectedDays.remove(day);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget to build time range pickers for the selected days
  Widget _buildSelectedDaysTimeRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _selectedDays.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${entry.key} Time Range', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTimePicker(
                    label: 'From',
                    selectedTime: entry.value.startTime,
                    onTimePicked: (pickedTime) {
                      setState(() {
                        _selectedDays[entry.key]?.startTime = pickedTime;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTimePicker(
                    label: 'To',
                    selectedTime: entry.value.endTime,
                    onTimePicked: (pickedTime) {
                      setState(() {
                        _selectedDays[entry.key]?.endTime = pickedTime;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  // Time picker widget
  Widget _buildTimePicker({required String label, required TimeOfDay? selectedTime, required Function(TimeOfDay) onTimePicked}) {
    return OutlinedButton(
      onPressed: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null) {
          onTimePicked(picked);
        }
      },
      child: Text(
        selectedTime != null ? selectedTime.format(context) : label,
      ),
    );
  }

  // TextField helper
  Widget _buildTextField(TextEditingController controller, String label, String? validatorMessage, {bool isNumber = false}) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          validator: validatorMessage != null ? (value) => value?.isEmpty ?? true ? validatorMessage : null : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Submit button widget
  ElevatedButton _buildSubmitButton(String text, bool isDay) {
    return ElevatedButton(
      onPressed: () => _submitService(isDay),
      child: Text(text.tr),
    );
  }
}

// Helper class to hold the time range for each day
class TimeRange {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
}