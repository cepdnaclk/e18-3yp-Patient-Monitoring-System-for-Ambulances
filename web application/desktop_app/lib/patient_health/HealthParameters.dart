import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:fl_chart/fl_chart.dart';

class ViewParameters extends StatefulWidget {
  // List<Patient> patients;
  // int patientIndex;
  Map<String, Patient> map;
  String deviceID;
  ViewParameters({super.key, required this.deviceID, required this.map});

  @override
  State<ViewParameters> createState() => _ViewParametersState(deviceID, map);
}

class _ViewParametersState extends State<ViewParameters> {
  Map<String, Patient> map;
  String deviceID;
  _ViewParametersState(this.deviceID, this.map);
  List<Point> temp = [];
  double time = 0;
  late bool flag;

  // late Patient pa;
  @override
  void initState() {
    super.initState();
    flag = false;
    temp = [];
    time = 0;
    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {
        temp.add(Point(time, map[deviceID]!));
        time += 2;
        if (time % 30 == 0) {
          flag = true;
        }
        if (flag) {
          temp.removeAt(0);
        }
        //log('from parameters $map');
      });
    });
  }

  Widget parameterTemplate(
      margin, String parameterName, double parameterValue) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        margin: margin,
        // width: 100,
        // height: 150,
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '$parameterName:',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                // height: 10,
                // width: 20,
                child: Center(
                  child: Text(
                      double.parse((parameterValue).toStringAsFixed(3))
                          .toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ]),
          // const SizedBox(height: 30),
          // Text(
          //   parameterValue.toString(),
          //   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          // )
          //TempGraphTemplate(temp)
        ]),
        // color: Colors.red,
      ),
    );
  }

  Widget graphTemplate(margin, List<FlSpot> points, double min, double max) {
    return Expanded(
      flex: 1,
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          margin: margin,
          // width: 100,
          // height: 150,
          child: AspectRatio(
            aspectRatio: 2,
            child: LineChart(LineChartData(minY: min, maxY: max,
                // titlesData: FlTitlesData(
                //   show: true,
                // ),
                lineBarsData: [
                  LineChartBarData(
                    spots:
                        points, //.map((e) => FlSpot(e.time, e.p.temperature)).toList(),
                    dotData: FlDotData(show: true),
                    isCurved: false,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                  )
                ])),
          )),
    );
  }

  // void updateChart(){
  //   temp[map[deviceID]!.temperature] = map[deviceID]
  // }
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Widget TempGraphTemplate(List<FlSpot> points) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(LineChartData(minY: 35, maxY: 40,
          // titlesData: FlTitlesData(
          //   show: true,
          // ),
          lineBarsData: [
            LineChartBarData(
              spots:
                  points, //.map((e) => FlSpot(e.time, e.p.temperature)).toList(),
              dotData: FlDotData(show: true),
              isCurved: false,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            )
          ])),
    );
  }

  // Widget TempGraphTemplate(List<Point> points) {
  //   return AspectRatio(
  //     aspectRatio: 5,
  //     child: LineChart(LineChartData(minY: 35, maxY: 40, lineBarsData: [
  //       LineChartBarData(
  //         spots: points.map((e) => FlSpot(e.time, e.p.temperature)).toList(),
  //         dotData: FlDotData(show: true),
  //         isCurved: false,
  //       )
  //     ])),
  //   );
  // }

  // Widget HRGraphTemplate(List<Point> points) {
  //   return AspectRatio(
  //     aspectRatio: 5,
  //     child: LineChart(LineChartData(lineBarsData: [
  //       LineChartBarData(
  //         spots: points.map((e) => FlSpot(e.time, e.p.heartRate)).toList(),
  //         dotData: FlDotData(show: true),
  //         isCurved: false,
  //       )
  //     ])),
  //   );
  // }

  // Widget PRGraphTemplate(List<Point> points) {
  //   return AspectRatio(
  //     aspectRatio: 5,
  //     child: LineChart(LineChartData(lineBarsData: [
  //       LineChartBarData(
  //         spots: points.map((e) => FlSpot(e.time, e.p.pulseRate)).toList(),
  //         dotData: FlDotData(show: true),
  //         isCurved: false,
  //       )
  //     ])),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(31, 0, 0, 0),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            height: 50,
            child: const Center(
                child: Text(
              'Heath Parameters',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
          )),
        ]),
        Row(
          children: <Widget>[
            parameterTemplate(
                const EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 10),
                'Temperature',
                map[deviceID]!.temperature),
            parameterTemplate(
                const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
                'Heart Rate',
                map[deviceID]!.heartRate)
          ],
        ),
        Row(
          children: <Widget>[
            parameterTemplate(
                const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 10),
                'Pulse Rate',
                map[deviceID]!.pulseRate),
            parameterTemplate(
                const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 10),
                'Oxygen Sat.',
                map[deviceID]!.oxygenSaturation)
          ],
        ),
        SizedBox(height: 30),
        Row(
          children: <Widget>[
            graphTemplate(
                const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
                temp.map((e) => FlSpot(e.time, e.p.temperature)).toList(),
                35.0,
                40.0),
            graphTemplate(
                const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
                temp.map((e) => FlSpot(e.time, e.p.heartRate)).toList(),
                50,
                200)
          ],
        ),
        Row(children: <Widget>[
          graphTemplate(
              const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
              temp.map((e) => FlSpot(e.time, e.p.pulseRate)).toList(),
              50,
              200),
          graphTemplate(
              const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
              temp.map((e) => FlSpot(e.time, e.p.oxygenSaturation)).toList(),
              10,
              200)
        ]),
        // Row(
        //   children: [
        //     Container(
        //         color: Colors.white,
        //         // height: 200,
        //         // width: 300,
        //         child: graphTemplate([1, 2])),
        //     Container(
        //         color: Colors.white,
        //         // height: 200,
        //         // width: 300,
        //         child: graphTemplate([1, 2])),
        //   ],
        // ),
        // Container(
        //     width: 400,
        //     margin: EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //         color: Colors.black.withOpacity(0.5),
        //         borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        //     child: TempGraphTemplate(temp)),
        // Container(
        //     margin: EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //         color: Colors.white.withOpacity(0.8),
        //         borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        //     child: HRGraphTemplate(temp)),
        // Container(
        //     margin: EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //         color: Colors.white.withOpacity(0.8),
        //         borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        //     child: PRGraphTemplate(temp)),
      ],

      // graphTemplate()
    );
  }
}

class Point {
  final double time;
  final Patient p;
  Point(this.time, this.p);
}
