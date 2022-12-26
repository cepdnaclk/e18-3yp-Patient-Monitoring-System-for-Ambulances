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

class Location extends StatefulWidget {
  //final double lat, long;
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late double lat;
  late double long;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lat = 6.927079;
    long = 79.861244;
    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {
        lat += 0.0001;
        long += 0.0001;
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
          center: latLng.LatLng(lat, long),
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
                point: latLng.LatLng(lat, long),
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
