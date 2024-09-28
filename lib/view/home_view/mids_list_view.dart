import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiplan_service/view_model/maid_model/maid_model.dart';

class MidsListScreen extends StatefulWidget {
  const MidsListScreen({super.key});

  @override
  State<MidsListScreen> createState() => _MidsListScreenState();
}

class _MidsListScreenState extends State<MidsListScreen> {
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
            country: maid['country'],
            imageUrl: maid['imageUrl'],
          );
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
  void initState() {
    // TODO: implement initState
    super.initState();
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
              return ListView.builder(
                  itemCount: maids.length,
                  itemBuilder: (context, index) {
                    MaidModel maid = maids[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  child: Image.network(maid.imageUrl),
                                ),
                                Text("الاسم : ${maid.name}"),
                                Text("الدولة : ${maid.country}"),
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
