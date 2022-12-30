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

class Location extends StatefulWidget {
  //final double lat, long;
  final String deviceID;
  final Map<String, Patient> map;
  const Location({super.key, required this.deviceID, required this.map});

  @override
  // ignore: no_logic_in_create_state
  State<Location> createState() => _LocationState(deviceID, map);
}

class _LocationState extends State<Location> {
  // late double lat;
  // late double long;
  Map<String, Patient> map;
  String deviceID;
  _LocationState(this.deviceID, this.map);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // lat = map[deviceID]!.lat;
    // long = map[deviceID]!.long;
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
          // color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(map[deviceID]!.lat, map[deviceID]!.long),
          zoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
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

    //Scaffold(
    //   appBar: AppBar(title: Text("amp")),
    //   body: Center(
    //     child: Container(
    //       child: Column(children: [
    //         Flexible(
    //           child: FlutterMap(options: MapOptions(
    //             center: latLng.LatLng(6.927079, 79.861244),
    //             zoom: 8
    //           ),
    //           layers: [

    //           ]
    //           )
    //           )
    //       ]),
    //     ),
    //   ),
    // );
  }
}
