import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:ambulance_tracking/pages/Connect.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ambulance_tracking/pages/Patient.dart';
import 'package:ambulance_tracking/pages/Chat.dart';
import 'package:ambulance_tracking/pages/Conn.dart';
// import 'package:ambulance_tracking/pages/MessageList.dart';
import 'package:ambulance_tracking/pages/Message.dart';
// import 'package:path_provider/path_provider.dart';

// Sing ss = '';
class ViewDetails extends StatefulWidget {
  const ViewDetails({Key? key}) : super(key: key);
  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController deviceIDController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  final MqttServerClient client = MqttServerClient(
      'a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com', '');
  late Patient patient;

  late String deviceID;
  late String hospitalID;
  late int age;
  late String name;
  late String condition;
  late bool firstClick;
  late bool isNameChanged;
  late bool isAgeChanged;
  late bool isConditionChanged;
  late int msgCount;
  late String deviceStatus;
  // late String temp;
  // late Timer time;
  late bool flag;

  Map<String, String> menuItems = {
    "Hospital1": "001",
    "Hospital2": "002",
    "Hospital3": "003"
  };
  late String selectedVal;
  late bool isActive;

  List<Message> messageFromHospital = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    patient = Patient.empty();
    deviceID = '';
    hospitalID = '';
    firstClick = true;
    isNameChanged = false;
    isAgeChanged = false;
    isConditionChanged = false;
    name = 'none';
    age = 0;
    condition = 'none';
    selectedVal = menuItems.keys.toList()[0];
    msgCount = 0;
    flag = false;

    deviceStatus = 'Offline';
    callMethod();
    isActive = false;
  }

  Future<void> callMethod() async {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() => {deviceStatus = 'Offline', isActive = false});
    });
  }

  Connection conn = Connection();

  void setupUpdatesListener() {
    conn
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      setState(() {
        flag = false;
        if (c[0].topic == '/AmbulanceProject/H$hospitalID/$deviceID') {
          if (pt == 'Active') {
            deviceStatus = 'Active';
            return;
          }
          flag = true;
          patient = Patient.fromJson(jsonDecode(pt));
          deviceStatus = 'Active';
          isActive = true;
        } else if (c[0].topic == 'message/from/hospital') {
          messageFromHospital.add(Message.fromJson(jsonDecode(pt),
              DateTime.now().subtract(const Duration(minutes: 1)), false));
          msgCount++;
          //message.add(Message.fromJson(jsonDecode(pt), DateTime.now().subtract(const Duration(minutes: 1)), false);

        }
      });
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  }

  delayed() async {
    await Future.delayed(Duration(seconds: 2)); // or some time consuming call
    return true;
  }

  Widget cardTemplate(
      String parameterName, double parameterValue, double maxValue) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: maxValue >= parameterValue ? Colors.blue[100] : Colors.red[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              // color: Colors.cyan,
              child: Text(parameterName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            const SizedBox(height: 20.0),
            Text(parameterValue.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('APP'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Colors.lightBlueAccent,
                  Colors.blue,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10.0),
                    height: 510,
                    width: 500,
                    // color: Colors.black26,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Device ID';
                            }
                            return null;
                          },
                          controller: deviceIDController,
                          decoration:
                              const InputDecoration(hintText: 'Device ID'),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            setState(() {
                              if ((value == null || value.isEmpty) &&
                                  !isNameChanged) {
                                name = 'none';
                              } else {
                                name = nameController.text;
                                isNameChanged = true;
                              }
                            });
                            return null;
                          },
                          decoration: const InputDecoration(hintText: 'Name'),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: ageController,
                          validator: (value) {
                            setState(() {
                              if ((value == null || value.isEmpty) &&
                                  !isAgeChanged) {
                                age = 0;
                              } else {
                                age = int.parse(ageController.text);
                                isAgeChanged = true;
                              }
                            });
                            return null;
                          },
                          decoration: const InputDecoration(hintText: 'Age'),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          // autofocus: false,
                          // initialValue: 'test',
                          controller: conditionController,
                          validator: (value) {
                            setState(() {
                              if ((value == null || value.isEmpty) &&
                                  !isConditionChanged) {
                                //isConditionChanged = false;
                                condition = 'none';
                              } else {
                                condition = conditionController.text;
                                isConditionChanged = true;
                              }
                            });
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: 'Condition'),
                        ),
                        const SizedBox(height: 30.0),
                        //hospital details
                        Container(
                            alignment: Alignment.topLeft,
                            width: 1000,
                            child: Column(children: <Widget>[
                              DropdownButton(
                                  value: selectedVal,
                                  items: menuItems.keys
                                      .toList()
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedVal = value as String;
                                    });
                                  })
                            ])),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  firstClick) {
                                setState(() {
                                  firstClick = false;
                                });
                                deviceID = deviceIDController.text;
                                hospitalID = menuItems[selectedVal].toString();

                                await conn.mqttConnect();

                                conn.subscribeTopic(
                                    '/AmbulanceProject/H$hospitalID/$deviceID');
                                conn.publishMsg(
                                    'Device_$deviceID', 'start:$hospitalID');
                                conn.subscribeTopic('message/from/hospital');
                                setupUpdatesListener();
                              }

                              patient.name = name;
                              patient.age = age;
                              patient.condition = condition;
                              log(name);
                              log(condition);
                              log(age.toString());
                              log(deviceID.toString());
                              log(patient.toString());
                              log(menuItems[selectedVal].toString());
                            },
                            child: const Text('Submit'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10.0),
                  // height: 500,
                  // width: 500,
                  child: Column(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(children: <Widget>[
                              const Text('Device Status:  ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0)),
                              Container(
                                //color: Colors.white,
                                padding: EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Text(deviceStatus,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: !isActive
                                            ? Colors.red.withOpacity(0.8)
                                            : Colors.green,
                                        fontStyle: FontStyle.italic)),
                              )
                            ]))),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 300,
                      width: 500,
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        children: <Widget>[
                          cardTemplate(
                              "Temperature", patient.temperature, 37.0),
                          cardTemplate("Heart Rate", patient.heartRate, 100.0),
                          cardTemplate("Pulse Rate", patient.pulseRate, 10.0),
                          cardTemplate(
                              "Oxygen Sat.", patient.oxygenSaturation, 20.0),
                        ],
                      ),
                    ),
                  ]),
                ),
                Container(
                  // color: Colors.deepOrange,
                  decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  padding: EdgeInsets.all(2.0),
                  height: 70,
                  width: 70,
                  child: Stack(children: <Widget>[
                    //Text('1'),
                    Align(
                      alignment: Alignment.topRight,
                      child: msgCount == 0
                          ? const Text('')
                          : Container(
                              height: 25,
                              width: 25,
                              padding:
                                  const EdgeInsets.only(bottom: 2.0, left: 6.0),
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              // color: Colors.red,

                              child: Text("$msgCount",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.white)),
                            ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: IconButton(
                          icon: const Icon(Icons.message, size: 40),
                          //iconSize: 40.0,
                          color: Colors.blueAccent,
                          padding: EdgeInsets.all(0),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.grey,
                            elevation: 10,
                            //hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
                          ),
                          onPressed: () {
                            setState(() {
                              msgCount = 0;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chat(
                                        conn,
                                        messageFromHospital,
                                        msgCount,
                                        hospitalID,
                                        deviceID)));
                          },
                        ),
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
