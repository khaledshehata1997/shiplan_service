import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OurLocationPage extends StatelessWidget {
  const OurLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // show location here on map
            const Text('Our Location'),

            // map with marker on our location in ksa
            Expanded(
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(24.774265, 46.738586), zoom: 10),
                  markers: {
                    const Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(24.774265, 46.738586))
                  },
                )),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: const Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Riyadh, KSA',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
