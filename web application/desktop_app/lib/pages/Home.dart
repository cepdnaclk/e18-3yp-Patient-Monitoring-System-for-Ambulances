import 'dart:async';
import 'dart:convert';

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
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Connection mqttConnection = Connection();
  List<Patient> patients = [];
  List<Message> messages = [];
  double lat = 6.927079;
  double long = 79.861244;
  late int patientCount;
  late Patient p;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    patientCount = 0;
    lat = 6.927079;
    long = 79.861244;
    p = Patient('none', 0, 'none', 0.0, 0.0, 0.0, 0.0);
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
        if (c[0].topic == '/AmbulanceProject/Hospital_001/111') {
          if (pt == 'Active') {
            return;
          }
          //patients.add(Patient.fromJson(jsonDecode(pt)));
          patientCount++;
          if (patientCount == 1) {
            p = Patient.fromJson(jsonDecode(pt));
            patients.add(p);
          } else {
            p = Patient.fromJson(jsonDecode(pt));
            patients[0] = p;
          }
          print('#############################################$patients');
        } else if (c[0].topic == 'chat/send/data') {
          print('#############################################$messages');
          messages.add(Message.fromJson(jsonDecode(pt),
              DateTime.now().subtract(const Duration(minutes: 1)), false));
        } else if (c[0].topic == 'map/data') {
          lat += 0.01;
          long += 0.01;
        }
      });
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  }

  Widget cardTemplate(int patientIndex, int patientNumber, List<Message> msgs,
      double lat, double long, List<Patient> patients) {
    //final Patient patient1 = Patient('name', 2, 'condition', 1, 1, 1, 1);
    return InkWell(
      onTap: () {
        print("Card Clicked");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientData(
                    patientIndex: patientIndex,
                    messages: msgs,
                    connect: mqttConnection,
                    lat: lat,
                    long: long,
                    patients: patients)));
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
            Align(
              alignment: Alignment.topLeft,
              child: Text('Patient $patientNumber',
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width < 1400 ? 20 : 30,
                      fontWeight: FontWeight.bold)),
            ),
            // Text(patient.name),
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
                children: patients
                    .map((patient) => cardTemplate(
                        patients.indexOf(patient),
                        patients.indexOf(patient) + 1,
                        messages,
                        lat,
                        long,
                        patients))
                    .toList(),
                // cardTemplate(context),
                // cardTemplate(context),
                // cardTemplate(context),
                // cardTemplate(context),
                // cardTemplate(context),
                // cardTemplate(context),
                // cardTemplate(context),
                // cardTemplate(context),

                // ElevatedButton(
                //   onPressed: () async {
                //     await mqttConnection.mqttConnect();
                //     mqttConnection
                //         .subscribeTopic('/AmbulanceProject/Hospital_001/+');
                //     setupUpdatesListener();
                //   },
                //   child: const Text('Login'),
                // ),
              )),
          ElevatedButton(
            onPressed: () async {
              await mqttConnection.mqttConnect();
              mqttConnection.subscribeTopic('/AmbulanceProject/Hospital_001/+');
              mqttConnection.subscribeTopic('chat/send/data');
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
