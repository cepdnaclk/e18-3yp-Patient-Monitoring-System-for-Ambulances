import 'package:flutter/material.dart';
import 'package:desktop_app/people/Patient.dart';

class ViewParameters extends StatefulWidget {
  final Patient patient;
  const ViewParameters(this.patient);

  @override
  State<ViewParameters> createState() => _ViewParametersState();
}

class _ViewParametersState extends State<ViewParameters> {
  Widget parameterTemplate(
      margin, String parameterName, double parameterValue) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        margin: margin,
        // width: 100,
        height: 200,
        child: Column(children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                parameterName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 50),
          Text(
            parameterValue.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ]),
        // color: Colors.red,
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
                widget.patient.temperature),
            parameterTemplate(
                const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 10),
                'Heart Rate',
                widget.patient.heartRate)
          ],
        ),
        Row(
          children: <Widget>[
            parameterTemplate(
                const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 10),
                'Pulse Rate',
                widget.patient.pulseRate),
            parameterTemplate(
                const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 10),
                'Oxygen Saturation',
                widget.patient.oxygenSaturation)
          ],
        )
      ],
    );
  }
}