import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_brand_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_brands_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/edit_brand_screen.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  List<GlobalKey> _dotKeys = [];

  @override
  void initState() {
    super.initState();
    _dotKeys = List.generate(100, (index) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Brands',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) => const AddBrandsScreen()))
                            .then((_) async {
                          await Future.delayed(const Duration(seconds: 1));

                          setState(() {});
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          backgroundColor: defaultColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Add New Brand'),
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: Provider.of<AddBrandController>(context, listen: false).fetchBrands(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var brands = snapshot.data!;
                    if (_dotKeys.length < brands.length) {
                      _dotKeys = List.generate(brands.length, (index) => GlobalKey());
                    }
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          brands.length,
                          (index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                          child: Image.memory(base64Decode(brands[index]['image'])),
                                        ),
                                      ),
                                    ),
                                    Text(brands[index]['name'])
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
                                                      builder: (context) => EditBrandScreen(
                                                        brandId: brands[index]['id'],
                                                        brandArName: brands[index]['nameAr'],
                                                        brandName: brands[index]['name'],
                                                        image: brands[index]['image'],
                                                      ),
                                                    ),
                                                  )
                                                      .then((_) async {
                                                    await Future.delayed(
                                                        const Duration(seconds: 1));

                                                    setState(() {});
                                                  });
                                                },
                                                child: Center(
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
                                          ),
                                          PopupMenuItem(
                                            child: GestureDetector(
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
                                                          const Text('Delete Brand'),
                                                          const Spacer(),
                                                          IconButton(
                                                            icon: const Icon(Icons.close),
                                                            onPressed: () =>
                                                                Navigator.of(context).pop(),
                                                          ),
                                                        ],
                                                      ),
                                                      content: const Text(
                                                          'Are you sure you want to delete this Brand?'),
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
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.of(context)
                                                                .pop(); // Close the dialog
                                                            // Call the delete function
                                                            await Provider.of<AddBrandController>(
                                                              context,
                                                              listen: false,
                                                            ).deleteBrand(brands[index]['id']);
                                                            setState(() {
                                                              brands.removeAt(index);
                                                            });
                                                          },
                                                          child: const Text('Delete'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 4),
                                                  SvgPicture.asset('assets/Trash.svg'),
                                                  const SizedBox(width: 10),
                                                  const Text('Delete'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    child: SvgPicture.asset('assets/dots.svg'))
                              ],
                            );
                          },
                        ));
                  } else {
                    return const Center(child: Text('No Brands found.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
