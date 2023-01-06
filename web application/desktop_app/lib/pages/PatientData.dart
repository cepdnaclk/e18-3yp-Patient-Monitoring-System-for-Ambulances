import 'dart:async';

import 'package:flutter/material.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:desktop_app/chat/Message.dart';
import 'package:desktop_app/chat/ChatWidget.dart';
import 'package:desktop_app/mqtt/MqttConnect.dart';
import 'package:desktop_app/patient_health/HealthParameters.dart';
import 'package:desktop_app/maps/Location.dart';
import 'package:desktop_app/people/Hospital.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  // Map<String, String> hospitalList;
  Map<String, Map<String, int>> transferPatient;
  Map<String, List<int>> msgCount;
  List<Hospital> hospitals;

  PatientData(
      {super.key,
      required this.hospitalID,
      required this.deviceID,
      required this.messages,
      required this.connect,
      required this.lat,
      required this.long,
      required this.map,
      required this.hospitals,
      required this.transferPatient,
      required this.msgCount});

  @override
  // ignore: no_logic_in_create_state
  State<PatientData> createState() => _PatientDataState(hospitalID, deviceID,
      messages, connect, lat, long, map, hospitals, transferPatient, msgCount);
}

class _PatientDataState extends State<PatientData> {
  // List<Patient> patients;
  // int patientIndex;
  Map<String, List<int>> msgCount;
  Map<String, Patient> map;
  List<Hospital> hospitals;
  String hospitalID;
  String deviceID;
  Map<String, List<Message>> messages;
  Connection connect;
  double lat, long;
  late Hospital selectedHospital;
  // Map<String, String> hospitalList;
  Map<String, Map<String, int>> transferPatient;
  _PatientDataState(
      this.hospitalID,
      this.deviceID,
      this.messages,
      this.connect,
      this.lat,
      this.long,
      this.map,
      this.hospitals,
      this.transferPatient,
      this.msgCount);
  @override
  void initState() {
    super.initState();
    //if()
    selectedHospital = hospitals[hospitals.indexWhere((element) =>
        element.id == transferPatient[deviceID]!.keys.toList()[0])];
    Timer.periodic(const Duration(seconds: 0), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {
        msgCount[deviceID]![0] = 0;
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
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    margin:
                        const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            const Text('Name:   ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Text(
                                  map[deviceID]!.name,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
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
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                // margin: const EdgeInsets.only(top: 4),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Text(
                                  map[deviceID]!.age == 0
                                      ? 'none'
                                      : map[deviceID]!.age.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Text(
                                        map[deviceID]!.condition,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              // alignment: Alignment.topLeft,
                              width: MediaQuery.of(context).size.width / 6,
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Center(
                                child: Column(children: <Widget>[
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                        dropdownWidth: 200,
                                        dropdownDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          // color: Colors.redAccent,
                                        ),
                                        selectedItemHighlightColor:
                                            const Color.fromARGB(
                                                255, 89, 172, 241),
                                        dropdownMaxHeight: 400,
                                        value: selectedHospital,
                                        items: hospitals
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: SingleChildScrollView(
                                                    child: SizedBox(
                                                      // color: Colors.amber,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              8,
                                                      child: Text(
                                                        e.name,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedHospital =
                                                value as Hospital;
                                          });
                                        }),
                                  )
                                ]),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (selectedHospital.id != hospitalID) {
                                transferPatient[deviceID] = {
                                  selectedHospital.id: 1
                                };
                              }
                            });

                            connect.publishMsg(
                                'TransferPatient/$hospitalID/${selectedHospital.id}',
                                deviceID);
                          },
                          child: const Text('Tranfer'),
                        ),
                        const Expanded(
                          child: SizedBox(),
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
                // msgCount: msgCount
              ),
            ),
          )
        ]),
      ),
    );
  }
}
