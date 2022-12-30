import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:desktop_app/chat/Message.dart';
import 'package:desktop_app/chat/ChatWidget.dart';
import 'package:desktop_app/mqtt/MqttConnect.dart';
import 'package:desktop_app/patient_health/HealthParameters.dart';
import 'package:desktop_app/maps/Location.dart';
import 'package:desktop_app/pages/Home.dart';

// ignore: must_be_immutable
class PatientData extends StatefulWidget {
  //List<Patient> patients;
  //int patientIndex;
  Map<String, List<Message>> messages;
  Connection connect;
  double lat, long;
  Map<String, Patient> map;
  String deviceID;
  String hospitalID;
  Map<String, String> hospitalList;
  Map<String, Map<String, int>> trnasferPatient;
  Map<String, MsgCount> msgCount;

  PatientData(
      {super.key,
      required this.hospitalID,
      required this.deviceID,
      required this.messages,
      required this.connect,
      required this.lat,
      required this.long,
      required this.map,
      required this.hospitalList,
      required this.trnasferPatient,
      required this.msgCount});

  @override
  // ignore: no_logic_in_create_state
  State<PatientData> createState() => _PatientDataState(
      hospitalID,
      deviceID,
      messages,
      connect,
      lat,
      long,
      map,
      hospitalList,
      trnasferPatient,
      msgCount);
}

class _PatientDataState extends State<PatientData> {
  // List<Patient> patients;
  // int patientIndex;
  Map<String, MsgCount> msgCount;
  Map<String, Patient> map;
  String hospitalID;
  String deviceID;
  Map<String, List<Message>> messages;
  Connection connect;
  double lat, long;
  late String selectedHospital;
  Map<String, String> hospitalList;
  Map<String, Map<String, int>> trnasferPatient;
  _PatientDataState(
      this.hospitalID,
      this.deviceID,
      this.messages,
      this.connect,
      this.lat,
      this.long,
      this.map,
      this.hospitalList,
      this.trnasferPatient,
      this.msgCount);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedHospital = trnasferPatient[deviceID]!.keys.toList()[0];
    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {
        // log('from patient data $map');
        //log(trnasferPatient[deviceID])
        // print(
        //     'form patientdata #################### ${messages[deviceID]} ###########################');
        msgCount[deviceID]!.count = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceID),
      ),
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
                child: ViewParameters(deviceID: deviceID, map: map),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(192, 0, 140, 255),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      margin: const EdgeInsets.all(10),
                      child: Location(deviceID: deviceID, map: map),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      margin: const EdgeInsets.only(
                          left: 10, bottom: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              const Text('Name:   ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: Text(
                                    map[deviceID]!.name,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text('Age:      ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  // margin: const EdgeInsets.only(top: 4),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: Text(
                                    map[deviceID]!.age == 0
                                        ? 'none'
                                        : map[deviceID]!.age.toString(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Condition:',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height: 80,
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                        child: Text(
                                          map[deviceID]!.condition,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              width: 1000,
                              child: Column(children: <Widget>[
                                DropdownButton(
                                    value: selectedHospital,
                                    items: hospitalList.keys
                                        .toList()
                                        .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedHospital = value as String;
                                      });
                                    })
                              ])),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (selectedHospital != hospitalID) {
                                  trnasferPatient[deviceID] = {
                                    selectedHospital: 1
                                  };
                                }
                              });

                              connect.publishMsg(
                                  'TransferPatient/$hospitalID/$selectedHospital',
                                  deviceID);
                            },
                            child: const Text('Send'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                    hospitalID: hospitalID,
                    msgCount: msgCount),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
