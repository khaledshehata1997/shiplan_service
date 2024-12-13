import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/constants/colors.dart';
import 'package:shiplan_service/temp_admin_lib/controller/advertisments_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_advertisment_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/edit_advertisment_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/categories_container.dart';

class AdvertismentsScreen extends StatefulWidget {
  const AdvertismentsScreen({super.key});

  @override
  State<AdvertismentsScreen> createState() => _AdvertismentsScreenState();
}

class _AdvertismentsScreenState extends State<AdvertismentsScreen> {
  List<GlobalKey> _dotKeys = [];
  @override
  void initState() {
    super.initState();
    _dotKeys = List.generate(100, (index) => GlobalKey()); // Adjust the size as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advertisments',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Provider.of<AdvertismentsController>(context, listen: false).fetchAdvertisment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var advertisments = snapshot.data!;
            if (_dotKeys.length < advertisments.length) {
              _dotKeys = List.generate(advertisments.length, (index) => GlobalKey());
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        advertisments.length,
                        (index) {
                          return Stack(
                            children: [
                              CategoriesContainer(
                                image: advertisments[index]['image'],
                              ),
                              Positioned(
                                right: 10,
                                top: 20,
                                child: GestureDetector(
                                  key: _dotKeys[index],
                                  onTap: () {
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
                                      items: [
                                        PopupMenuItem(
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey
                                                  .shade200, // Grey background for the first ListTile
                                              borderRadius: BorderRadius.circular(
                                                  10), // Rounded corners for the container
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) => EditAdvertismentScreen(
                                                    advertismentId: advertisments[index]['id'],
                                                    image: advertisments[index]['image'],
                                                  ),
                                                ))
                                                    .then((_) async {
                                                  await Future.delayed(const Duration(seconds: 1));

                                                  setState(() {});
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset('assets/Pencil.svg'),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
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
                                                        const Text(
                                                          'Delete Advertisment',
                                                          style: TextStyle(fontSize: 19),
                                                        ),
                                                        const Spacer(),
                                                        IconButton(
                                                          icon: const Icon(Icons.close),
                                                          onPressed: () =>
                                                              Navigator.of(context).pop(),
                                                        ),
                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'Are you sure you want to delete this Advertisment?'),
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
                                                          await Provider.of<
                                                              AdvertismentsController>(
                                                            context,
                                                            listen: false,
                                                          ).deleteAdvertisment(
                                                              advertisments[index]['id']);
                                                          setState(() {
                                                            advertisments.removeAt(index);
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
                                  child: SvgPicture.asset('assets/dots.svg'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (ctx) => const AddAdvertismentScreen()))
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
                                Text('Add New Advertisment'),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No advertisments found.'));
          }
        },
      ),
    );
  }
}
