import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../view_model/service_model/service_model.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  String? _selectedValue;
  List<String> listOfValue = [
    'أستقدام',
    'تأجير',
  ];
  final summaryController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final serviceTypeController = TextEditingController();
  final maidCountryController = TextEditingController();
  final freeDaysController = TextEditingController();
  final hoursController = TextEditingController();
  final vistCountController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceAfterTaxController = TextEditingController();
  @override
  void initState() {
    priceController.text = '0';
    priceAfterTaxController.text = '0';
    super.initState();
  }

  bool isLoading = false;
  String error = '';
  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fromKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('add product'.tr),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                // pick image button

                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  value: _selectedValue,
                  hint: Text(
                    'choose one',
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
                // upload image button
                TextFormField(
                  controller: summaryController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter service summary';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'service summary'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'title'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: serviceTypeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter service type';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'service type'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: freeDaysController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter free days';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'free days'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: maidCountryController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter maid country';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'maid country'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: hoursController,
                  decoration: InputDecoration(
                    labelText: 'hours'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: vistCountController,
                  decoration: InputDecoration(
                    labelText: 'vistCount'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'price'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceAfterTaxController,
                  decoration: InputDecoration(
                    labelText: 'price after tax'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // add button
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_fromKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              if (_selectedValue == "أستقدام") {
                                print(
                                    "sadsadsdsaadadsadsads ${_selectedValue}");
                                ServicesService.addDayService(ServiceModel(
                                    maidId: "1",
                                    hours: int.parse(hoursController.text),
                                    vistCount:
                                        int.parse(vistCountController.text),
                                    serviceSummary: summaryController.text,
                                    isDay: true,
                                    maidCountry: maidCountryController.text,
                                    serviceType: serviceTypeController.text,
                                    description: descriptionController.text,
                                    freeDays: {},
                                    title: titleController.text,
                                    id: Uuid().v4(),
                                    regularPrice:
                                        double.parse(priceController.text),
                                    priceAfterTax: double.parse(
                                        priceAfterTaxController.text)));
                              } else if (_selectedValue == "تأجير") {
                                print(
                                    "sadsadsdsaadadsadsads ${_selectedValue}");

                                ServicesService.addRentDayService(ServiceModel(
                                    maidId: "1",
                                    hours: int.parse(hoursController.text),
                                    vistCount:
                                        int.parse(vistCountController.text),
                                    serviceSummary: summaryController.text,
                                    maidCountry: maidCountryController.text,
                                    isDay: true,
                                    serviceType: serviceTypeController.text,
                                    description: descriptionController.text,
                                    freeDays: {},
                                    title: titleController.text,
                                    id: Uuid().v4(),
                                    regularPrice:
                                        double.parse(priceController.text),
                                    priceAfterTax: double.parse(
                                        priceAfterTaxController.text)));
                              }

                              setState(() {
                                isLoading = false;
                              });
                              Get.back();
                              Get.snackbar(
                                  'Success', 'Service added successfully');
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                                error = e.toString();
                              });
                            }
                          }
                        },
                        child: Text('Add day service'.tr),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_fromKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              if (_selectedValue == "أستقدام") {
                                print(
                                    "sadsadsdsaadadsadsads ${_selectedValue}");

                                ServicesService.addNightService(ServiceModel(
                                    maidId: "1",
                                    hours: int.parse(hoursController.text),
                                    vistCount:
                                        int.parse(vistCountController.text),
                                    serviceSummary: summaryController.text,
                                    isDay: false,
                                    maidCountry: maidCountryController.text,
                                    serviceType: serviceTypeController.text,
                                    description: descriptionController.text,
                                    freeDays: {},
                                    title: titleController.text,
                                    id: Uuid().v4(),
                                    regularPrice:
                                        double.parse(priceController.text),
                                    priceAfterTax: double.parse(
                                        priceAfterTaxController.text)));
                              } else if (_selectedValue == "تأجير") {
                                print(
                                    "sadsadsdsaadadsadsads ${_selectedValue}");

                                ServicesService.addRentNightService(
                                    ServiceModel(
                                        maidId: "1",
                                        hours: int.parse(hoursController.text),
                                        vistCount:
                                            int.parse(vistCountController.text),
                                        serviceSummary: summaryController.text,
                                        maidCountry: maidCountryController.text,
                                        isDay: false,
                                        serviceType: serviceTypeController.text,
                                        description: descriptionController.text,
                                        freeDays: {},
                                        title: titleController.text,
                                        id: Uuid().v4(),
                                        regularPrice:
                                            double.parse(priceController.text),
                                        priceAfterTax: double.parse(
                                            priceAfterTaxController.text)));
                              }

                              setState(() {
                                isLoading = false;
                              });
                              Get.back();
                              Get.snackbar(
                                  'Success', 'Service added successfully');
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                                error = e.toString();
                              });
                            }
                          }
                        },
                        child: Text('Add night service'.tr),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
