import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:desktop_app/data/Points.dart';

// ignore: must_be_immutable
class ViewParameters extends StatefulWidget {
  Map<String, List<Point>> data;
  Map<String, Patient> map;
  String deviceID;
  ViewParameters(
      {super.key,
      required this.deviceID,
      required this.map,
      required this.data});

  @override
  State<ViewParameters> createState() =>
      // ignore: no_logic_in_create_state
      _ViewParametersState(deviceID, map, data);
}

class _ViewParametersState extends State<ViewParameters> {
  Map<String, Patient> map;
  String deviceID;
  Map<String, List<Point>> data;
  _ViewParametersState(this.deviceID, this.map, this.data);
  late double time;
  late bool flag;

  @override
  void initState() {
    super.initState();
    flag = false;

    time = data[deviceID]![data[deviceID]!.length - 1].time;

    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }

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
        time += 2;
        data[deviceID]!.add(Point(time, x));

        if (data[deviceID]!.length >= 10) {
          data[deviceID]!.removeAt(0);
        }
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
            color: !outRange ? Colors.black12 : Colors.black.withOpacity(0.3),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        margin: margin,
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
          graphTemplate(
              list, minValue, maxValue, parameterName, rightTitles, outRange),
        ]),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
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
                sideTitles: SideTitles(showTitles: false, reservedSize: 40),
              ),
              rightTitles: rightTitles,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: points,
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
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          )),
        ]),
        Row(
          children: <Widget>[
            parameterTemplate(
              const EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 10),
              'Temperature(°C)',
              map[deviceID]!.temperature,
              data[deviceID]!
                  .map((e) => FlSpot(e.time, e.p.temperature))
                  .toList(),
              0,
              40,
              AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  interval: 5,
                  getTitlesWidget: leftTitleWidgets,
                ),
              ),
              36,
              38,
            ),
            parameterTemplate(
                const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
                'Heart Rate(bpm)',
                map[deviceID]!.heartRate,
                data[deviceID]!
                    .map((e) => FlSpot(e.time, e.p.heartRate))
                    .toList(),
                0,
                150,
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
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
                'Pulse Rate(bpm)',
                map[deviceID]!.pulseRate,
                data[deviceID]!
                    .map((e) => FlSpot(e.time, e.p.pulseRate))
                    .toList(),
                0,
                150,
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    interval: 25,
                    getTitlesWidget: leftTitleWidgets,
                  ),
                ),
                0,
                120),
            parameterTemplate(
                const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 10),
                'Oxygen Sat.(%)',
                map[deviceID]!.oxygenSaturation,
                data[deviceID]!
                    .map((e) => FlSpot(e.time, e.p.oxygenSaturation))
                    .toList(),
                0,
                100,
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    interval: 20,
                    getTitlesWidget: leftTitleWidgets,
                  ),
                ),
                30,
                90)
          ],
        ),
      ],
    );
  }
}
