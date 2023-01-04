import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// import 'dart:io';
import 'package:ambulance_tracking/pages/Login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:ambulance_tracking/pages/Connect.dart';
import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ambulance_tracking/pages/Patient.dart';
import 'package:ambulance_tracking/pages/Chat.dart';
import 'package:ambulance_tracking/pages/Conn.dart';
// import 'package:ambulance_tracking/pages/MessageList.dart';
import 'package:ambulance_tracking/pages/Message.dart';
// import 'package:path_provider/path_provider.dart';

// Sing ss = '';
class ViewDetails extends StatefulWidget {
  final String userName;
  const ViewDetails(this.userName);
  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController deviceIDController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  // final MqttServerClient client = MqttServerClient( 'a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com', '');
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
  // late int msgCount;
  late String deviceStatus;
  // late String temp;
  // late Timer time;
  // late bool flag;
  late bool isHospitalChanged;

  Map<String, String> menuItems = {
    "Hospital1": "H001",
    "Hospital2": "H002",
    "Hospital3": "H003"
  };
  late String selectedVal;
  late bool isActive;
  late String ambulanceStatus;
  MsgCount msgCount = MsgCount();

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
    msgCount.count = 0;

    // flag = false;
    ambulanceStatus = '';
    isHospitalChanged = false;

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
        // flag = false;
        if (c[0].topic == '/AmbulanceProject/$hospitalID/$deviceID') {
          if (pt == 'Active') {
            deviceStatus = 'Active';
            return;
          }
          // flag = true;
          patient = Patient.fromJson(jsonDecode(pt));
          deviceStatus = 'Active';
          isActive = true;
        } else if (c[0].topic == 'Mobile/Transfer/$deviceID') {
          ambulanceStatus = 'Tranferred to $pt';
          hospitalID = pt;
          // isHospitalChanged = true;
          // Future.delayed(Duration(seconds: 5), () {
          //   isHospitalChanged = false;
          // });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Tranfer'),
                  content: Text('Transfer to $hospitalID'),
                  actions: <Widget>[
                    // TextButton(
                    //   onPressed: () => Navigator.pop(context, 'Cancel'),
                    //   child: const Text('Cancel'),
                    // ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
        } else if (c[0].topic.substring(0, 22) == 'message/from/hospital/') {
          messageFromHospital.add(Message.fromJson(jsonDecode(pt),
              DateTime.now().subtract(const Duration(minutes: 1)), false));
          msgCount.count++;
          //message.add(Message.fromJson(jsonDecode(pt), DateTime.now().subtract(const Duration(minutes: 1)), false);
        }
      });
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  }

  // delayed() async {
  //   await Future.delayed(Duration(seconds: 2)); // or some time consuming call
  //   return true;
  // }

  Widget cardTemplate(
      String parameterName, double parameterValue, double maxValue) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: maxValue >= parameterValue ? Colors.blue[100] : Colors.red[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
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
          automaticallyImplyLeading: false,
          title: const Text('APP'),
        ),
        body: SingleChildScrollView(
          key: ValueKey('scrollFinder'),
          child: Container(
            padding: const EdgeInsets.all(20.0),
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
                          key: ValueKey('HospitalIDFinder'),
                          enabled: firstClick,
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
                              Row(
                                children: [
                                  DropdownButton(
                                      value: selectedVal,
                                      items: menuItems.keys
                                          .toList()
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                      onChanged: firstClick
                                          ? (value) {
                                              setState(() {
                                                selectedVal = value as String;
                                              });
                                            }
                                          : null),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      height: 35,
                                      padding: const EdgeInsets.only(
                                          top: 8, left: 5, right: 5),
                                      decoration: BoxDecoration(
                                        color: ambulanceStatus != ''
                                            ? Colors.white70
                                            : null,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                      child: Text(ambulanceStatus,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0)))
                                ],
                              )
                            ])),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            key: ValueKey('submitBtnFinder'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  firstClick) {
                                deviceID = deviceIDController.text;
                                hospitalID = menuItems[selectedVal].toString();
                                setState(() {
                                  firstClick = false;
                                  ambulanceStatus = 'Directed to $hospitalID';
                                });

                                await conn.mqttConnect(widget.userName);

                                conn.subscribeTopic(
                                    '/AmbulanceProject/$hospitalID/$deviceID');
                                conn.publishMsg(
                                    'Device_$deviceID', 'start:$hospitalID');
                                conn.subscribeTopic(
                                    'message/from/hospital/+/$deviceID');
                                conn.subscribeTopic(
                                    'Mobile/Transfer/$deviceID');
                                setupUpdatesListener();
                              }

                              patient.name = name;
                              patient.age = age;
                              patient.condition = condition;
                              Future.delayed(const Duration(seconds: 4), () {
                                conn.publishMsg(
                                    'PatientData/$hospitalID/$deviceID',
                                    '{"name":"${patient.name}", "age":${patient.age}, "condition": "${patient.condition}"}');
                              });
                              // conn.publishMsg(
                              //     'PatientData/$hospitalID/$deviceID',
                              //     '{"name":${patient.name}, "age":${patient.age}, "condition": ${patient.condition}}');
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
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(10.0),
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
                                padding: const EdgeInsets.all(3),
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
                              ),
                              //Text(ambulanceStatus),
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
                  // color: Colors.amber,
                  // padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: <Widget>[
                      const Expanded(flex: 1, child: SizedBox()),
                      Container(
                        // color: Colors.deepOrange,
                        decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        padding: const EdgeInsets.all(2.0),
                        height: 70,
                        width: 70,
                        child: Stack(children: <Widget>[
                          //Text('1'),
                          Align(
                            alignment: Alignment.topRight,
                            child: msgCount.count == 0
                                ? const Text('')
                                : Container(
                                    height: 25,
                                    width: 25,
                                    padding: const EdgeInsets.only(
                                        bottom: 2.0, left: 6.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    // color: Colors.red,

                                    child: Text("${msgCount.count}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                  ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: IconButton(
                                key: ValueKey('chatIconFinder'),
                                icon: const Icon(Icons.message, size: 40),
                                //iconSize: 40.0,
                                color: Colors.blueAccent,
                                padding: const EdgeInsets.all(0),
                                style: IconButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  elevation: 10,
                                  //hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
                                ),
                                onPressed: () {
                                  setState(() {
                                    msgCount.count = 0;
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
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        // color: Colors.deepOrange,
                        decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        // padding: EdgeInsets.all(2.0),
                        height: 70,
                        width: 70,
                        child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: IconButton(
                                key: ValueKey('stopIconFinder'),
                                icon: const Icon(Icons.stop_circle, size: 50),
                                //iconSize: 40.0,
                                color: Colors.red.withOpacity(0.7),
                                padding: const EdgeInsets.all(0),
                                style: IconButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  elevation: 10,
                                  //hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
                                ),
                                onPressed: () {
                                  setState(() {
                                    conn.publishMsg(
                                        'Device_$deviceID', 'stop:');
                                    conn.publishMsg(
                                        'Stop/$hospitalID/$deviceID',
                                        'Arrived');
                                    conn.disconnect();
                                    Future.delayed(const Duration(seconds: 5),
                                        () {
                                      patient = Patient.empty();
                                      deviceStatus = 'Offline';
                                      isActive = false;
                                      firstClick = true;
                                      ambulanceStatus = '';
                                      messageFromHospital.clear();
                                      msgCount.count = 0;
                                    });
                                    // patient = Patient.empty();
                                    // deviceStatus = 'Offline';
                                    // isActive = false;
                                    // firstClick = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        // color: Colors.deepOrange,
                        decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        // padding: EdgeInsets.all(2.0),
                        height: 70,
                        width: 70,
                        child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: IconButton(
                                key: ValueKey('logoutFinder'),
                                icon: const Icon(Icons.logout, size: 50),
                                //iconSize: 40.0,
                                color: Colors.red.withOpacity(0.7),
                                padding: const EdgeInsets.all(0),
                                style: IconButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  elevation: 10,
                                  //hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
                                ),
                                onPressed: () {
                                  // setState(() {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('LogOut'),
                                          content: const Text(
                                              'Are you sure you want to logout ?',
                                              key: ValueKey(
                                                  'logoutConfirmationFinder')),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Login())),
                                              child: const Text(
                                                'OK',
                                                key: ValueKey('logoutOKBtn'),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                  // });
                                },
                              ),
                            ),
                          ),
                        ]),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class MsgCount {
  late int count;
}
