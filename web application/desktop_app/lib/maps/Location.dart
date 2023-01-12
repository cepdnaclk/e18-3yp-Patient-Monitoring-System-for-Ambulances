// import 'dart:async';
import 'dart:async';

import 'package:latlng/latlng.dart';
import 'package:latlong2/latlong.dart' as latLng;
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong/Circle.dart';
// import 'package:latlong2/latlong/Distance.dart';
// import 'package:latlong2/latlong/LatLng.dart';
// import 'package:latlong2/latlong/LengthUnit.dart';
// import 'package:latlong2/latlong/Path.dart';
// import 'package:latlong2/latlong/calculator/Haversine.dart';
// import 'package:latlong2/latlong/calculator/Vincenty.dart';
// import 'package:latlong2/latlong/interfaces.dart';
// import 'package:latlong2/spline.dart';
// import 'package:latlong2/spline/CatmullRomSpline.dart';
// // import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import "package:latlong/latlong.dart" as LatLng;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:desktop_app/people/Hospital.dart';

class Location extends StatefulWidget {
  //final double lat, long;
  Map<String, Map<Hospital, int>> transferPatient;
  String deviceID;
  Map<String, Patient> map;
  Location(
      {super.key,
      required this.deviceID,
      required this.map,
      required this.transferPatient});

  @override
  // ignore: no_logic_in_create_state
  State<Location> createState() =>
      // ignore: no_logic_in_create_state
      _LocationState(deviceID, map, transferPatient);
}

class _LocationState extends State<Location> {
  Map<String, Map<Hospital, int>> transferPatient;
  Map<String, Patient> map;
  String deviceID;
  _LocationState(this.deviceID, this.map, this.transferPatient);

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {
        map[deviceID]!.lat += 0.0001;
        map[deviceID]!.long += 0.0001;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(map[deviceID]!.lat, map[deviceID]!.long),
          zoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: latLng.LatLng(
                    double.parse(
                        transferPatient[deviceID]!.keys.toList()[0].lat),
                    double.parse(
                        transferPatient[deviceID]!.keys.toList()[0].long)),
                width: 80,
                height: 80,
                builder: (context) => const Icon(
                  Icons.local_hospital,
                  color: Colors.blueAccent,
                  size: 30,
                ),
              ),
              Marker(
                point: latLng.LatLng(map[deviceID]!.lat, map[deviceID]!.long),
                width: 80,
                height: 80,
                builder: (context) => const Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 209, 27, 14),
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
