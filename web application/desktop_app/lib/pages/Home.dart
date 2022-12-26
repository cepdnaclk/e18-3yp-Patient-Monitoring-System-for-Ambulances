import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:desktop_app/mqtt/MqttConnect.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:desktop_app/pages/PatientData.dart';
import 'package:desktop_app/chat/Message.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:web_application/api/ApiConnection.dart';

class Home extends StatefulWidget {
  String hospitalID;
  Home({super.key, required this.hospitalID});

  @override
  State<Home> createState() => _HomeState(hospitalID);
}

class _HomeState extends State<Home> {
  String hospitalID;
  _HomeState(this.hospitalID);
  Connection mqttConnection = Connection();
  Map<String, Patient> map = {};
  // List<Patient> patients = [];
  Map<String, List<Message>> messages = {};
  Map<String, int> msgCount = {};
  // List<Message> messages = [];
  double lat = 6.927079;
  double long = 79.861244;
  late int patientCount;
  // late Patient p;
  String deviceID = 'none';
  // Map<Patient, double> chartData = {};
  // late int i;
  // late int messageCount;
  // late bool isHomePage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isHomePage = true;
    patientCount = 0;
    // messageCount = 0;
    // i = 0;
    lat = 6.927079;
    long = 79.861244;
    deviceID = 'none';
    //p = Patient('none', 0, 'none', 0.0, 0.0, 0.0, 0.0);
    // Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
    //   if (!mounted) {
    //     return;
    //   }
    //   setState(() {
    //     PatientData(patient, messages, mqttConnection, lat, long);
    //   });
    // });
  }

  int rowCount() {
    double width = MediaQuery.of(context).size.width;
    if (width > 1000) {
      return 5;
    } else if (width <= 1000 && width >= 750) {
      return 3;
    }
    return 2;
  }

  void setupUpdatesListener() {
    mqttConnection
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      setState(() {
        if (c[0].topic.substring(0, c[0].topic.length - 3) ==
            '/AmbulanceProject/$hospitalID/') {
          if (pt == 'Active') {
            return;
          }
          deviceID =
              c[0].topic.substring(c[0].topic.length - 3, c[0].topic.length);
          // if (pt.contains('message')) {
          //   if (messages[deviceID] == null) {
          //     messages[deviceID] = [];
          //     msgCount[deviceID] = 0;
          //   }
          //   messages[deviceID]!.add(Message.fromJson(jsonDecode(pt),
          //       DateTime.now().subtract(const Duration(minutes: 1)), false));
          //   msgCount[deviceID] = msgCount[deviceID]! + 1;
          //   return;
          // }

          if (!map.containsKey(deviceID)) {
            patientCount++;
            // i++;
          }
          map[deviceID] = Patient.fromJson(jsonDecode(pt));
          // chartData[Patient.fromJson(jsonDecode(pt))] =
          // }else{
          //   map[deviceID] =
          // }
          //for (int i = 0; i < patients.length; i++) {}
          //patients.add(Patient.fromJson(jsonDecode(pt)));

          log(map[deviceID]!.name);
          // if (patientCount == 1) {
          //   p = Patient.fromJson(jsonDecode(pt));
          //   patients.add(p);
          // } else {
          //   p = Patient.fromJson(jsonDecode(pt));
          //   patients[0] = p;
          // }
          //print('#############################################$patients');
          // } else if (c[0].topic == 'chat/send/data') {
          //   print('#############################################$messages');
          //   messages.add(Message.fromJson(jsonDecode(pt),
          //       DateTime.now().subtract(const Duration(minutes: 1)), false));
        } else if (c[0].topic == 'map/data') {
          lat += 0.01;
          long += 0.01;
        } else if (c[0].topic.substring(0, c[0].topic.length - 3) ==
            'message/from/ambulance/$hospitalID/') {
          deviceID =
              c[0].topic.substring(c[0].topic.length - 3, c[0].topic.length);
          if (messages[deviceID] == null) {
            messages[deviceID] = [];
            msgCount[deviceID] = 0;
          }
          messages[deviceID]!.add(Message.fromJson(jsonDecode(pt),
              DateTime.now().subtract(const Duration(minutes: 1)), false));
          msgCount[deviceID] = msgCount[deviceID]! + 1;
        }
      });
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  }

  Widget cardTemplate(
      String deviceID,
      int patientNumber,
      Map<String, List<Message>> msgs,
      double lat,
      double long,
      Map<String, Patient> map,
      Map<String, int> msgCount) {
    //final Patient patient1 = Patient('name', 2, 'condition', 1, 1, 1, 1);
    return InkWell(
      onTap: () {
        setState(() {
          msgCount[deviceID] = 0;
        });
        //print("Card Clicked");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientData(
                    hospitalID: hospitalID,
                    deviceID: deviceID,
                    messages: msgs,
                    connect: mqttConnection,
                    lat: lat,
                    long: long,
                    map: map)));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // padding: const EdgeInsets.all(20),
        // height: 100,
        // width: 400,
        // decoration: BoxDecoration(
        //   color: Colors.white70.withOpacity(0.5),
        //   borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text('Patient $patientNumber',
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width < 1400 ? 20 : 30,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 35,
              ),
              Container(
                // height: 40,
                width: 25,
                padding: EdgeInsets.all(0),
                // decoration: const BoxDecoration(
                //   // color: Colors.amber,
                //   // borderRadius: BorderRadius.all(Radius.circular(15.0))
                // ),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.only(left: 1),
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          color: msgCount[deviceID] != null &&
                                  msgCount[deviceID] != 0
                              ? const Color.fromARGB(255, 255, 0, 0)
                              : null,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                      child: Center(
                        child: Text(
                          msgCount[deviceID] == null && msgCount[deviceID] != 0
                              ? ''
                              : msgCount[deviceID]!.toString(),
                          style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.message,
                    //color: Colors.green,

                    size: 16.0,
                  ),
                ]),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Device ID: $deviceID',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            // Text(patient.condition)
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients ($patientCount)',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color.fromARGB(255, 86, 177, 251),
                    Color.fromARGB(255, 3, 141, 255),
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              // padding: const EdgeInsets.all(50),
              margin: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 2 / 3,
              width: MediaQuery.of(context).size.width,
              // color: Colors.black.withOpacity(0.2),
              child: GridView.count(
                padding: const EdgeInsets.all(50),
                crossAxisCount: rowCount(),
                mainAxisSpacing:
                    MediaQuery.of(context).size.width < 750 ? 60 : 30,
                crossAxisSpacing:
                    MediaQuery.of(context).size.width < 750 ? 60 : 30,
                childAspectRatio: 2 / 1,
                children: map.entries
                    .map((entry) => cardTemplate(
                        entry.key,
                        map.keys.toList().indexOf(entry.key) + 1,
                        messages,
                        lat,
                        long,
                        map,
                        msgCount))
                    .toList(),
              )),
          ElevatedButton(
            onPressed: () async {
              await mqttConnection.mqttConnect();
              mqttConnection.subscribeTopic('/AmbulanceProject/$hospitalID/+');
              mqttConnection
                  .subscribeTopic('message/from/ambulance/$hospitalID/+');
              mqttConnection.subscribeTopic('map/data');
              setupUpdatesListener();
            },
            child: const Text('Connect'),
          ),
        ]),
      ),
    );
  }
}
