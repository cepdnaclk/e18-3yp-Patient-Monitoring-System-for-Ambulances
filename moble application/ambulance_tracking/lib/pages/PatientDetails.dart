import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ambulance_tracking/users/Hospital.dart';
import 'package:ambulance_tracking/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:ambulance_tracking/users/Patient.dart';
import 'package:ambulance_tracking/pages/Chat.dart';
import 'package:ambulance_tracking/pages/Connection.dart';
import 'package:ambulance_tracking/pages/Message.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// Sing ss = '';
class ViewDetails extends StatefulWidget {
  final String userName;
  final List<Hospital> hospitals;
  const ViewDetails(this.userName, this.hospitals, {super.key});
  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController deviceIDController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
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
  late String deviceStatus;
  late bool flag;

  late bool isHospitalChanged;

  late Hospital selectedVal;
  late bool isActive;
  late String ambulanceStatus;
  MsgCount msgCount = MsgCount();

  List<Message> messageFromHospital = [];
  @override
  void initState() {
    super.initState();
    flag = false;
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
    selectedVal = widget.hospitals[
        widget.hospitals.indexWhere((element) => element.id == "H001")];
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
      if (!mounted) {
        return;
      }
      setState(() => {deviceStatus = 'Offline', isActive = false});
    });
  }

  // @override
  // void dispose() {
  //   // textEditingController.dispose();
  //   // ignore: avoid_print
  //   log('Dispose used');
  //   super.dispose();
  // }

  Connection conn = Connection();

  void setupUpdatesListener() {
    conn
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      setState(() {
        if (c[0].topic == '/AmbulanceProject/$hospitalID/$deviceID') {
          if (pt == 'Active') {
            deviceStatus = 'Active';
            return;
          }

          // patient = Patient.fromJson(jsonDecode(pt));
          patient.healthData(jsonDecode(pt));
          deviceStatus = 'Active';
          isActive = true;
          flag = !flag ? true : false;
        } else if (c[0].topic == 'Mobile/Transfer/$deviceID') {
          // conn.unsubscribeTopic('/AmbulanceProject/$hospitalID/$deviceID');
          // conn.unsubscribeTopic('message/from/hospital/$hospitalID/$deviceID');
          ambulanceStatus = 'Tranferred to $pt';
          hospitalID = pt;
          // log(hospitalID);
          // log(deviceID);
          // log('message/from/hospital/$hospitalID/$deviceID');
          // log('/AmbulanceProject/$hospitalID/$deviceID');
          conn.subscribeTopic('message/from/hospital/$hospitalID/$deviceID');
          conn.subscribeTopic('/AmbulanceProject/$hospitalID/$deviceID');

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Transfer Message'),
                  content: Text(
                      'Transferred to $hospitalID: ${widget.hospitals[widget.hospitals.indexWhere((element) => element.id == hospitalID)].name}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
        } else if (c[0].topic == 'Mobile/Stop/$deviceID') {
          conn.disconnect();
          Future.delayed(const Duration(seconds: 5), () {
            patient = Patient.empty();
            deviceStatus = 'Offline';
            isActive = false;
            firstClick = true;
            ambulanceStatus = '';
            messageFromHospital.clear();
            msgCount.count = 0;
            deviceIDController.clear();
            nameController.clear();
            ageController.clear();
            conditionController.clear();
            flag = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Stop Message'),
                  content: Text('Stopped Device: $deviceID'),
                  actions: <Widget>[
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
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'You cannot go to previous screen when you are logged in. Click logout button'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Text(widget.userName),
                const Expanded(flex: 3, child: SizedBox()),
                Text(ambulanceStatus,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0)),
                const SizedBox(
                  width: 6,
                ),
                Container(
                  // margin: const EdgeInsets.only(top: 2),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: flag && !ambulanceStatus.contains('Tranferred')
                        ? Colors.amber
                        : flag && ambulanceStatus.contains('Tranferred')
                            ? Colors.red.withOpacity(0.8)
                            : null,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                const Expanded(flex: 4, child: SizedBox()),
              ],
            ),
          ),
          body: SingleChildScrollView(
            key: ValueKey('scrollFinder'),
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(10.0),
                      // height: 520,
                      // width: 500,
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
                            decoration: InputDecoration(
                                fillColor: Colors.blue[100],
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'Device ID',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                            // decoration:
                            //     InputDecoration(hintText: 'Device ID'),
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
                            decoration: InputDecoration(
                                fillColor: Colors.blue[100],
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'Name',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                          ),
                          const SizedBox(height: 30.0),
                          TextFormField(
                            decoration: InputDecoration(
                                fillColor: Colors.blue[100],
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'Age',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
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
                            // decoration: InputDecoration(hintText: 'Age'),
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
                            decoration: InputDecoration(
                                fillColor: Colors.blue[100],
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'Condition',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                          ),
                          const SizedBox(height: 30.0),
                          //hospital details
                          Align(
                            alignment: Alignment.topCenter,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                  selectedItemHighlightColor:
                                      const Color.fromARGB(255, 115, 186, 233),
                                  buttonHeight: 40,
                                  buttonPadding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  // buttonWidth: 360,
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.blue[100],
                                  ),
                                  dropdownMaxHeight: 200,
                                  dropdownWidth: 250,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  value: selectedVal,
                                  items: widget.hospitals
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e.name,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: firstClick
                                      ? (value) {
                                          setState(() {
                                            selectedVal = value as Hospital;
                                          });
                                        }
                                      : null),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              key: ValueKey('submitBtnFinder'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    firstClick) {
                                  deviceID = deviceIDController.text;
                                  hospitalID = selectedVal.id;
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
                                      'message/from/hospital/$hospitalID/$deviceID');
                                  conn.subscribeTopic(
                                      'Mobile/Transfer/$deviceID');
                                  conn.subscribeTopic('Mobile/Stop/$deviceID');
                                  setupUpdatesListener();
                                }
                                patient.name = name;
                                patient.age = age;
                                patient.condition = condition;
                                if (_formKey.currentState!.validate()) {
                                  Future.delayed(const Duration(seconds: 4),
                                      () {
                                    log('PatientData/$hospitalID/$deviceID');
                                    conn.publishMsg(
                                        'PatientData/$hospitalID/$deviceID',
                                        '{"name":"${patient.name}", "age":${patient.age}, "condition": "${patient.condition}"}');
                                  });

                                  log(patient.name);
                                  log(condition);
                                  log(age.toString());
                                  log(deviceID.toString());
                                  log(patient.toString());
                                  log(selectedVal.name);
                                }
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
                        // color: Colors.amber,
                        height: 335,
                        // width: 500,
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          children: <Widget>[
                            cardTemplate(
                                "Temperature", patient.temperature, 37.0),
                            cardTemplate(
                                "Heart Rate", patient.heartRate, 100.0),
                            cardTemplate("Pulse Rate", patient.pulseRate, 10.0),
                            cardTemplate(
                                "Oxygen Sat.", patient.oxygenSaturation, 20.0),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  Row(
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
                                      deviceIDController.clear();
                                      nameController.clear();
                                      ageController.clear();
                                      conditionController.clear();
                                      flag = false;
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
                                              key: ValueKey('logoutOKBtn'),
                                              onPressed: () {
                                                conn.disconnect();
                                                // dispose();
                                                deactivate();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Login()));
                                              },
                                              child: const Text(
                                                'OK',
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
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class MsgCount {
  late int count;
}
