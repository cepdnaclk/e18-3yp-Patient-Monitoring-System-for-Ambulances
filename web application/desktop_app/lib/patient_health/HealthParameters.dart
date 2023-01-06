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
      // double y = DateTime.now().second * 1.0;
      Patient x = Patient(
          map[deviceID]!.name,
          map[deviceID]!.age,
          map[deviceID]!.condition,
          map[deviceID]!.temperature,
          map[deviceID]!.heartRate,
          map[deviceID]!.pulseRate,
          map[deviceID]!.oxygenSaturation,
          map[deviceID]!.lat,
          map[deviceID]!.long);
      setState(() {
        temp.add(Point(time, x));
        time += 2;
        if (time % 30 == 0) {
          flag = true;
          // time = 0;
        }
        if (flag) {
          temp.removeAt(0);
        }
        //log('from parameters $map');
      });
    });
  }

  Widget parameterTemplate(
      margin,
      String parameterName,
      double parameterValue,
      List<FlSpot> list,
      double minValue,
      double maxValue,
      rightTitles,
      double minLim,
      double maxLim) {
    bool outRange =
        minLim > parameterValue || maxLim < parameterValue ? true : false;
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: !outRange ? Colors.black12 : Colors.black.withOpacity(0.4),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        margin: margin,
        // width: 100,
        // height: 300,
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
                decoration: BoxDecoration(
                    color: !outRange
                        ? Colors.white
                        : const Color.fromARGB(255, 244, 172, 166),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
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

          graphTemplate(
              list, minValue, maxValue, parameterName, rightTitles, outRange),
          // Text('time'),
          // const RotationTransition(
          //     turns: AlwaysStoppedAnimation(270 / 360),
          //     child: Text("flutter is awesome"))
        ]),
        // color: Colors.red,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    // const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value.floor()}',
        style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 8,
            fontStyle: FontStyle.italic),
      ),
    );
  }
  // Widget graphTemplate(margin, List<FlSpot> points, double min, double max) {
  //   return Expanded(
  //     flex: 1,
  //     child: Container(
  //         padding: const EdgeInsets.all(5),
  //         decoration: BoxDecoration(
  //             color: Colors.black.withOpacity(0.5),
  //             borderRadius: const BorderRadius.all(Radius.circular(10.0))),
  //         margin: margin,
  //         // width: 100,
  //         // height: 150,
  //         child: AspectRatio(
  //           aspectRatio: 2,
  //           child: LineChart(LineChartData(minY: min, maxY: max,
  //               // titlesData: FlTitlesData(
  //               //   show: true,
  //               // ),
  //               lineBarsData: [
  //                 LineChartBarData(
  //                   spots:
  //                       points, //.map((e) => FlSpot(e.time, e.p.temperature)).toList(),
  //                   dotData: FlDotData(show: true),
  //                   isCurved: false,
  //                   belowBarData: BarAreaData(
  //                     show: true,
  //                     gradient: LinearGradient(
  //                       colors: gradientColors
  //                           .map((color) => color.withOpacity(0.3))
  //                           .toList(),
  //                     ),
  //                   ),
  //                 )
  //               ])),
  //         )),
  //   );
  // }

  // void updateChart(){
  //   temp[map[deviceID]!.temperature] = map[deviceID]
  // }
  List<Color> gradientColors1 = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<Color> gradientColors2 = [
    const Color.fromARGB(255, 230, 35, 35),
    const Color.fromARGB(255, 211, 138, 2),
  ];

  Widget graphTemplate(List<FlSpot> points, double minValue, double maxValue,
      String title, rightTitles, bool outRange) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.only(top: 20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: LineChart(LineChartData(
            minY: minValue,
            maxY: maxValue,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                axisNameWidget: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                      fontStyle: FontStyle.italic),
                ),
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 30,
                ),
              ),
              topTitles: AxisTitles(
                axisNameWidget: Text(
                  'time: ${DateTime.now().toString().substring(11, 19)}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                      fontStyle: FontStyle.italic),
                ),
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 30,
                ),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false, reservedSize: 100
                    // getTitlesWidget: bottomTitleWidgets,
                    ),
              ),
              rightTitles: rightTitles,
              // AxisTitles(
              //   sideTitles: SideTitles(
              //     showTitles: true,
              //     reservedSize: 25,
              //     interval: 50,
              //     getTitlesWidget: leftTitleWidgets,
              //   ),
              // ),
            ),
            // titlesData: AxisTitles(),
            lineBarsData: [
              LineChartBarData(
                spots:
                    points, //.map((e) => FlSpot(e.time, e.p.temperature)).toList(),
                dotData: FlDotData(show: true),
                isCurved: false,
                gradient: outRange
                    ? LinearGradient(
                        colors: [
                          ColorTween(
                                  begin: const Color.fromARGB(255, 169, 71, 64),
                                  end: const Color.fromARGB(255, 232, 81, 70))
                              .lerp(0.2)!,
                          ColorTween(
                                  begin: const Color.fromARGB(255, 238, 103, 6),
                                  end: const Color.fromARGB(255, 235, 140, 24))
                              .lerp(0.2)!,
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          ColorTween(
                                  begin: gradientColors1[0],
                                  end: gradientColors1[0])
                              .lerp(0.2)!,
                          ColorTween(
                                  begin: gradientColors1[1],
                                  end: gradientColors1[1])
                              .lerp(0.2)!,
                        ],
                      ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: !outRange
                        ? gradientColors1
                            .map((color) => color.withOpacity(0.3))
                            .toList()
                        : gradientColors2
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                  ),
                ),
              ),
            ])),
      ),
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
              'Health Parameters',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
          )),
        ]),
        Row(
          children: <Widget>[
            parameterTemplate(
              const EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 10),
              'Temperature',
              map[deviceID]!.temperature,
              temp.map((e) => FlSpot(e.time, e.p.temperature)).toList(),
              35,
              40,
              AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  interval: 1,
                  getTitlesWidget: leftTitleWidgets,
                ),
              ),
              36,
              38,
            ),
            parameterTemplate(
                const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
                'Heart Rate',
                map[deviceID]!.heartRate,
                temp.map((e) => FlSpot(e.time, e.p.heartRate)).toList(),
                60,
                150,
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    interval: 25,
                    getTitlesWidget: leftTitleWidgets,
                  ),
                ),
                60,
                120)
          ],
        ),
        Row(
          children: <Widget>[
            parameterTemplate(
                const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 10),
                'Pulse Rate',
                map[deviceID]!.pulseRate,
                temp.map((e) => FlSpot(e.time, e.p.pulseRate)).toList(),
                60,
                150,
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    interval: 25,
                    getTitlesWidget: leftTitleWidgets,
                  ),
                ),
                60,
                120),
            parameterTemplate(
                const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 10),
                'Oxygen Sat.',
                map[deviceID]!.oxygenSaturation,
                temp.map((e) => FlSpot(e.time, e.p.oxygenSaturation)).toList(),
                10,
                100,
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    interval: 25,
                    getTitlesWidget: leftTitleWidgets,
                  ),
                ),
                30,
                90)
          ],
        ),
        // SizedBox(height: 30),
        // Row(
        //   children: <Widget>[
        //     graphTemplate(
        //         const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
        //         temp.map((e) => FlSpot(e.time, e.p.temperature)).toList(),
        //         35.0,
        //         40.0),
        //     graphTemplate(
        //         const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
        //         temp.map((e) => FlSpot(e.time, e.p.heartRate)).toList(),
        //         50,
        //         200)
        //   ],
        // ),
        // Row(children: <Widget>[
        //   graphTemplate(
        //       const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
        //       temp.map((e) => FlSpot(e.time, e.p.pulseRate)).toList(),
        //       50,
        //       200),
        //   graphTemplate(
        //       const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
        //       temp.map((e) => FlSpot(e.time, e.p.oxygenSaturation)).toList(),
        //       10,
        //       200)
        // ]),
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
