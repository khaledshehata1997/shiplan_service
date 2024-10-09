import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shiplan_service/constants.dart';
import 'package:shiplan_service/view/cv_viewer_screen.dart';
import 'package:shiplan_service/view_model/maid_model/maid_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMidsByCountery extends StatefulWidget {
  String maidCountry;
  ViewMidsByCountery({super.key, required this.maidCountry});

  @override
  State<ViewMidsByCountery> createState() => _ViewMidsByCounteryState();
}

class _ViewMidsByCounteryState extends State<ViewMidsByCountery> {
  List<MaidModel> _maids = [];
  Future<void> _loadMaids() async {
    List<MaidModel> fetchedMaids = await fetchMaids();
    setState(() {
      _maids = fetchedMaids;
    });
  }

  Future<List<MaidModel>> fetchMaids() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('maids')
          .doc('maidList')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic> maidServiceList =
            (snapshot.data() as Map<String, dynamic>)['maidService'] ?? [];

        List<MaidModel> maids = maidServiceList.map((maid) {
          return MaidModel(
              id: maid['id'] ?? "",
              name: maid['name'],
              age: maid['age'],
              country: maid['country'] ?? "",
              imageUrl: maid['imageUrl'] ?? "",
              cvUrl: maid['cvUrl'] ?? "");
        }).toList();

        return maids;
      } else {
        print('Document does not exist or has no maidServiceList');
        return [];
      }
    } catch (e) {
      print('Error fetching maids: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'الخادمات',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<List<MaidModel>>(
          future: fetchMaids(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No services found'));
            } else {
              List<MaidModel> maids = snapshot.data!;
              maids.removeWhere((maid) => maid.country != widget.maidCountry);
              return ListView.builder(
                  itemCount: maids.length,
                  itemBuilder: (context, index) {
                    MaidModel maid = maids[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(maid.imageUrl),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "الاسم : ${maid.name}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        Text(
                                          "السن : ${maid.age}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "الدولة : ${maid.country}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainColor,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () async {
                                          String phoneNumber =
                                              "+201140045515"; // Replace with your WhatsApp number
                                          String message =
                                              "الاسم: ${maid.name} \n"
                                              "السن: ${maid.age} \n"
                                              "الدولة: ${maid.country} \n"
                                              "السيرة الذاتية: ${maid.cvUrl} \n"
                                              "التاريخ: ${DateTime.now().toIso8601String()}";

                                          String whatsappUrl =
                                              "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";

                                          // Launch WhatsApp with the new method
                                          Uri url = Uri.parse(whatsappUrl);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            Get.snackbar('Error',
                                                'Could not launch WhatsApp.');
                                          }
                                        },
                                        child: const Text("طلب الخدمة")),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: secondColor,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Get.to(() => CVViewerScreen(
                                              cvPath: maid.cvUrl));
                                        },
                                        child:
                                            const Text("عرض السيرة الذاتية")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
