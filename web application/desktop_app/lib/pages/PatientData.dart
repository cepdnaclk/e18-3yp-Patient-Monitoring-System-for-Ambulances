import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:desktop_app/chat/Message.dart';
import 'package:desktop_app/chat/ChatWidget.dart';
import 'package:desktop_app/mqtt/MqttConnect.dart';
import 'package:desktop_app/patient_health/HealthParameters.dart';
import 'package:desktop_app/maps/Location.dart';

class PatientData extends StatefulWidget {
  //List<Patient> patients;
  //int patientIndex;
  Map<String, List<Message>> messages;
  Connection connect;
  double lat, long;
  Map<String, Patient> map;
  String deviceID;
  String hospitalID;

  PatientData(
      {super.key,
      required this.hospitalID,
      required this.deviceID,
      required this.messages,
      required this.connect,
      required this.lat,
      required this.long,
      required this.map});

  @override
  State<PatientData> createState() => _PatientDataState(
      hospitalID, deviceID, messages, connect, lat, long, map);
}

class _PatientDataState extends State<PatientData> {
  // List<Patient> patients;
  // int patientIndex;
  Map<String, Patient> map;
  String hospitalID;
  String deviceID;
  Map<String, List<Message>> messages;
  Connection connect;
  double lat, long;
  _PatientDataState(this.hospitalID, this.deviceID, this.messages, this.connect,
      this.lat, this.long, this.map);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {
        // log('from patient data $map');
        print(
            'form patientdata #################### ${messages[deviceID]} ###########################');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(deviceID)),
      body: Center(
        child: Container(
          // color: Color.fromARGB(155, 0, 140, 254),
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment(0.8, 1),
          //     colors: <Color>[
          //       Color.fromARGB(255, 20, 177, 249),
          //       Color.fromARGB(255, 0, 105, 192),
          //     ],
          //     tileMode: TileMode.mirror,
          //   ),
          // ),
          child: Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(1, 1),
                      colors: <Color>[
                        Color.fromARGB(227, 64, 195, 255),
                        Color.fromARGB(234, 33, 149, 243),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: ViewParameters(deviceID: deviceID, map: map)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(192, 0, 140, 255),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                margin: const EdgeInsets.all(10),
                child: const Location(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(1, 1),
                      colors: <Color>[
                        Color.fromARGB(227, 64, 195, 255),
                        Color.fromARGB(234, 33, 149, 243),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                margin: const EdgeInsets.all(10),
                child: Chat(
                    mess: messages,
                    connect: connect,
                    deviceID: deviceID,
                    hospitalID: hospitalID),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
