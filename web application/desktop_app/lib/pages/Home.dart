import 'dart:convert';
import 'dart:developer';
import 'package:desktop_app/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:desktop_app/mqtt/MqttConnect.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:desktop_app/pages/PatientData.dart';
import 'package:desktop_app/chat/Message.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:desktop_app/people/Hospital.dart';
import 'package:desktop_app/file/GeneratePDF.dart';
import 'package:desktop_app/pages/Admin.dart';
import 'package:desktop_app/data/Points.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  String hospitalID;
  List<Hospital> hospitals;
  Home({super.key, required this.hospitalID, required this.hospitals});

  @override
  // ignore: no_logic_in_create_state
  State<Home> createState() => _HomeState(hospitalID, hospitals);
}

class _HomeState extends State<Home> {
  String hospitalID;
  List<Hospital> hospitals;
  _HomeState(this.hospitalID, this.hospitals);
  Connection mqttConnection = Connection();
  Map<String, Patient> map = {};
  Map<String, List<Message>> messages = {};
  Map<String, List<int>> msgCount = {};
  Map<String, List<bool>> isArrived =
      {}; //index 0 for arriving and 1 for stopping
  Map<String, String> ambulanceStatus = {};
  // Map<String, String> hospitalList = {
  //   'H001': 'Hospital1',
  //   'H002': 'Hospital2',
  //   'H003': 'Hospital3'
  // };

  PDF pdf = PDF();

  Map<String, Map<Hospital, int>> transferPatient =
      {}; // 0 for initial hospital 1 for tranfering hospital 2 for transferrd hospital
  Map<String, List<String>> requests = {};

  double lat = 6.927079;
  double long = 79.861244;
  late int patientCount;
  // late bool isArrived;
  String deviceID = 'none';
  late int requestCount;
  late bool isConnected;
  final Map<String, List<double>> parameterLimits = {
    'Temp': [35.0, 40.0],
    'HR': [60.0, 150.0],
    'PL': [60.0, 150.0],
    'OS': [10.0, 100.0]
  };

  late Map<String, bool> isOutRange = {};
  Map<String, List<Point>> data = {};
  // late String ambulanceStatus;
  @override
  void initState() {
    super.initState();
    requestCount = 0;
    patientCount = 0;
    lat = 6.927079;
    long = 79.861244;
    deviceID = 'none';
    isConnected = false;
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

//listen to incoming messages
  void setupUpdatesListener() {
    mqttConnection
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      setState(() {
        //listen to initial message from device
        if (pt == 'Active') {
          return;
        }

        //if the message contain heath parameters
        if (c[0].topic.substring(0, c[0].topic.length - 3) ==
            '/AmbulanceProject/$hospitalID/') {
          deviceID =
              c[0].topic.substring(c[0].topic.length - 3, c[0].topic.length);
          if (!map.containsKey(deviceID)) {
            patientCount++;
            map[deviceID] = Patient.empty();
            isArrived[deviceID] = [false, false];
            ambulanceStatus[deviceID] = 'Arriving';
            data[deviceID] = [
              Point(0, Patient.empty()),
              Point(2, Patient.empty()),
              Point(4, Patient.empty())
            ];
            transferPatient[deviceID] = {
              hospitals[hospitals
                  .indexWhere((element) => element.id == hospitalID)]: 0
            };
            // msgCount[deviceID] = MsgCount();
            msgCount[deviceID] = [0];
            isOutRange[deviceID] = false;
          }

          //check wether ambulance still arriving
          isArrived[deviceID]![0] = isArrived[deviceID]![0] ? false : true;

          //decode health parameters
          map[deviceID]!.healthData(jsonDecode(pt));
          Patient pa = Patient.empty();
          pa.healthData(jsonDecode(pt));
          data[deviceID]!.add(Point(data[deviceID]!.last.time + 2, pa));
          data[deviceID]!.removeAt(0);
          for (int i = 0; i < data[deviceID]!.length; i++) {
            log('${data[deviceID]![i].time}--${data[deviceID]![i].p.heartRate}');
          }

          //check wether health parameters out of range
          isOutRange[deviceID] = map[deviceID]!.temperature <
                      parameterLimits['Temp']![0] ||
                  map[deviceID]!.temperature > parameterLimits['Temp']![1] ||
                  map[deviceID]!.heartRate < parameterLimits['HR']![0] ||
                  map[deviceID]!.heartRate > parameterLimits['HR']![1] ||
                  map[deviceID]!.pulseRate < parameterLimits['PL']![0] ||
                  map[deviceID]!.pulseRate > parameterLimits['PL']![1] ||
                  map[deviceID]!.oxygenSaturation < parameterLimits['OS']![0] ||
                  map[deviceID]!.oxygenSaturation > parameterLimits['OS']![1]
              ? true
              : false;

          //message from the ambulance
        } else if (c[0].topic.substring(0, c[0].topic.length - 3) ==
            'message/from/ambulance/$hospitalID/') {
          deviceID =
              c[0].topic.substring(c[0].topic.length - 3, c[0].topic.length);
          if (messages[deviceID] == null) {
            messages[deviceID] = [];
          }
          messages[deviceID]!.add(Message.fromJson(jsonDecode(pt),
              DateTime.now().subtract(const Duration(minutes: 1)), false));
          msgCount[deviceID]![0]++;

          //message to change patient personal details
        } else if (c[0].topic.substring(0, c[0].topic.length - 3) ==
            'PatientData/$hospitalID/') {
          deviceID =
              c[0].topic.substring(c[0].topic.length - 3, c[0].topic.length);
          map[deviceID]!.personalData(jsonDecode(pt));

          //stop signal from ambulance
        } else if (c[0].topic.substring(0, c[0].topic.length - 3) ==
            'Stop/$hospitalID/') {
          deviceID =
              c[0].topic.substring(c[0].topic.length - 3, c[0].topic.length);
          ambulanceStatus[deviceID] = 'Arrived';
          isArrived[deviceID]![1] = true;

          //sending transfer request to another hospital
        } else if (c[0].topic.substring(0, c[0].topic.length - 4) ==
            'TransferPatient/$hospitalID/') {
          String requestedHospital =
              c[0].topic.substring(c[0].topic.length - 4, c[0].topic.length);
          //if(requestedHospital == )
          ambulanceStatus[pt] =
              requestedHospital != hospitalID ? 'Transfering...' : 'Arriving';

          //requsest coming from another hospital
        } else if (c[0].topic.substring(0, 16) == 'TransferPatient/' &&
            c[0].topic.substring(c[0].topic.length - 4, c[0].topic.length) ==
                hospitalID) {
          String requestedHospital =
              c[0].topic.substring(16, c[0].topic.length - 5);
          String device = pt.substring(pt.length - 3, pt.length);
          if (pt.substring(0, pt.length - 3) == 'Accepted:') {
            ambulanceStatus[device] = 'Transferred';
            transferPatient[device]![hospitals[hospitals
                .indexWhere((element) => element.id == requestedHospital)]] = 2;
            mqttConnection.publishMsg('PatientData/$requestedHospital/$device',
                '{"name":"${map[device]!.name}", "age":${map[device]!.age}, "condition": "${map[device]!.condition}"}');
          } else if (pt.substring(0, pt.length - 3) == 'Rejected:') {
            transferPatient[device] = {
              hospitals[hospitals
                  .indexWhere((element) => element.id == hospitalID)]: 0
            };
            ambulanceStatus[device] = '$requestedHospital Rejected!';
          } else if (!map.containsKey(pt) && !pt.contains('Rejected')) {
            if (!requests.containsKey(requestedHospital)) {
              requests[requestedHospital] = [];
            }
            if (!requests[requestedHospital]!.contains(pt)) {
              requests[requestedHospital]!.add(pt);
              requestCount++;
            }
          }
        }
      });
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  }

  Widget requestTemplate(String hospital, List<String> device) {
    return SingleChildScrollView(
      child: Container(
        // height: 200,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blueAccent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      'Hospital ID: $hospital',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Container(
                      width: 15,
                      decoration: const BoxDecoration(
                        // border: Border.all(color: Colors.blueAccent),
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Center(
                        child: Text(
                          '${device.length}',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )),
            Column(
                children: device.map((e) => deviceItem(e, hospital)).toList())
          ],
        ),
      ),
    );
  }

  Widget deviceItem(String device, String hospital) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        // color: Colors.amber,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Device ID: $device',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                  ),
                  onPressed: () {
                    setState(() {
                      requestCount--;
                      mqttConnection.publishMsg('Device_$device',
                          'change:$hospital-${hospitals[hospitals.indexWhere((element) => element.id == hospital)].name}');
                      mqttConnection.publishMsg(
                          'Mobile/Transfer/$device', hospitalID);
                      mqttConnection.publishMsg(
                          'TransferPatient/$hospitalID/$hospital',
                          'Accepted:$device');
                      patientCount++;
                      map[device] = Patient.empty();
                      data[device] = [
                        Point(0, Patient.empty()),
                        Point(2, Patient.empty()),
                        Point(4, Patient.empty())
                      ];
                      // log('${data[deviceID]![0].time} ${data[deviceID]![1].time} ${data[deviceID]![2].time}');
                      // // log(time.toString());
                      // log(data[deviceID]!.length.toString());
                      isArrived[device] = [false, false];
                      ambulanceStatus[device] = 'Arriving';
                      transferPatient[device] = {
                        hospitals[hospitals.indexWhere(
                            (element) => element.id == hospitalID)]: 0
                      };
                      msgCount[device] = [0];
                      isOutRange[device] = false;

                      // msgCount[deviceID] = [0];
                      requests[hospital]!
                          .removeAt(requests[hospital]!.indexOf(device));
                      if (requests[hospital]!.isEmpty) {
                        requests.remove(hospital);
                      }
                    });
                  },
                  child: const Text('Accept'),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    // Background color
                  ),
                  onPressed: () {
                    setState(() {
                      requestCount--;
                      // log('TransferPatient/$hospital/$hospitalID');
                      mqttConnection.publishMsg(
                          'TransferPatient/$hospital/$hospitalID',
                          'Rejected:$device');
                      requests[hospital]!
                          .removeAt(requests[hospital]!.indexOf(device));
                      if (requests[hospital]!.isEmpty) {
                        requests.remove(hospital);
                      }
                    });
                  },
                  child: const Text('Reject'),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget cardTemplate(
    String deviceID,
    int patientNumber,
    // Map<String, List<Message>> msgs,
    // double lat,
    //double long,
    //Map<String, Patient> map,
    // Map<String, MsgCount> msgCount
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          // if (msgCount[deviceID] == null) {
          //   msgCount[deviceID] = [];
          // }
          msgCount[deviceID]![0] = 0;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientData(
                    hospitalID: hospitalID,
                    deviceID: deviceID,
                    messages: messages,
                    connect: mqttConnection,
                    lat: lat,
                    long: long,
                    map: map,
                    transferPatient: transferPatient,
                    msgCount: msgCount,
                    hospitals: hospitals,
                    data: data)));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: isArrived[deviceID]![1]
            ? const Color.fromARGB(255, 159, 244, 161)
            : transferPatient[deviceID]!.values.toList()[0] == 1
                ? const Color.fromARGB(255, 222, 247, 131)
                : transferPatient[deviceID]!.values.toList()[0] == 2
                    ? const Color.fromARGB(255, 244, 238, 68)
                    : isOutRange[deviceID]!
                        ? const Color.fromARGB(255, 255, 149, 142)
                        : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text('Patient $patientNumber',
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width < 1400 ? 15 : 20,
                        fontWeight: FontWeight.bold)),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Container(
                // color: Colors.white,
                // height: 40,
                width: 25,
                padding: const EdgeInsets.all(0),

                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.only(left: 1),
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          color: msgCount[deviceID] != null &&
                                  msgCount[deviceID]![0] != 0
                              ? const Color.fromARGB(255, 255, 0, 0)
                              : null,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                      child: Center(
                        child: Text(
                          msgCount[deviceID] == null
                              ? ''
                              : msgCount[deviceID]![0] == 0
                                  ? ''
                                  : msgCount[deviceID]![0].toString(),
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
                    size: 13,
                  ),
                ]),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                // color: Colors.amber,
                margin: const EdgeInsets.all(2),
                height: 20,
                width: 20,
                // padding: EdgeInsets.only(bottom: 4),
                child: ambulanceStatus[deviceID] == 'Transferred' ||
                        ambulanceStatus[deviceID] == 'Arrived'
                    ? FloatingActionButton(
                        // hoverColor: Colo,
                        // label: Text(''),
                        heroTag: "btn1",
                        hoverElevation: 0,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        // padding: EdgeInsets.all(0),
                        hoverColor: Colors.red.withOpacity(0.3),
                        // focusColor: Colors.red,
                        // highlightColor: Colors.black,
                        child: const Icon(
                          Icons.cancel,
                          color: Color.fromARGB(255, 225, 19, 5),
                          size: 15,
                        ),

                        onPressed: () {
                          setState(() {
                            map.remove(deviceID);
                            isArrived.remove(deviceID);
                            ambulanceStatus.remove(deviceID);
                            transferPatient.remove(deviceID);
                            messages.remove(deviceID);
                            msgCount.remove(deviceID);
                            data.remove(deviceID);
                            patientCount--;
                          });
                        },
                        //child: const Text('Accept'),
                      )
                    : null,
              )
            ]),
            const SizedBox(
              height: 2,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Device ID: $deviceID',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10),
                )),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      ambulanceStatus[deviceID]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10),
                    )),
                const SizedBox(
                  width: 7,
                ),
                //if (isArrived[deviceID]!) ...[],
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: isArrived[deviceID]![0] || isArrived[deviceID]![1]
                        ? (!isArrived[deviceID]![1]
                            ? Colors.red.withOpacity(0.8)
                            : Colors.green.withOpacity(0.8))
                        : null,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                // color: Colors.amber,
                margin: const EdgeInsets.only(top: 3),
                height: 20,
                width: 20,
                child: isArrived[deviceID]![1]
                    ? FloatingActionButton(
                        // hoverColor: Colo,
                        // label: Text(''),
                        heroTag: "btn2",
                        hoverElevation: 0,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        hoverColor: const Color.fromARGB(255, 96, 194, 243)
                            .withOpacity(0.3),

                        child: const Icon(
                          Icons.file_download,
                          color: Color.fromARGB(255, 63, 62, 62),
                          size: 15,
                        ),

                        onPressed: () {
                          pdf.createPDF(
                              map[deviceID]!,
                              hospitals[hospitals.indexWhere(
                                  (element) => element.id == hospitalID)],
                              deviceID,
                              isOutRange[deviceID]!);
                        },
                        //child: const Text('Accept'),
                      )
                    : null,
              ),
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Text('Patients ($patientCount)',
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const Expanded(
              child: SizedBox(
                  //width: MediaQuery.of(context).size.width - 500,
                  ),
            ),
            Column(children: <Widget>[
              // SizedBox(
              //   height: 10,
              // ),
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                    customButton: const Icon(
                      Icons.add_alert_sharp,
                      size: 35,
                    ),
                    offset: const Offset(-230, 0),
                    //icon: Icon(Icons.add_alert_sharp),
                    buttonHeight: 40,
                    itemHeight: 150,
                    dropdownWidth: 250,
                    dropdownMaxHeight: 600,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color.fromARGB(255, 59, 164, 250),
                    ),
                    // isExpanded: true,
                    value: null,
                    items: requests.entries
                        .map((e) => DropdownMenuItem(
                            value: e, child: requestTemplate(e.key, e.value)))
                        .toList(),
                    onChanged: (value) {}),
              )
            ]),
            Container(
              // width: 15,
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent),
                color: requestCount == 0 ? null : Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Center(
                child: Text(
                  requestCount == 0 ? '' : requestCount.toString(),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
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
              height: MediaQuery.of(context).size.height * 2.1 / 3,
              width: MediaQuery.of(context).size.width,
              // color: Colors.black.withOpacity(0.2),
              child: GridView.count(
                padding: const EdgeInsets.all(50),
                crossAxisCount: rowCount(),
                mainAxisSpacing:
                    MediaQuery.of(context).size.width < 750 ? 60 : 30,
                crossAxisSpacing:
                    MediaQuery.of(context).size.width < 750 ? 60 : 30,
                childAspectRatio: 16 / 9,
                children: map.entries
                    .map((entry) => cardTemplate(
                          entry.key,
                          map.keys.toList().indexOf(entry.key) + 1,
                          // messages,
                          // lat,
                          // long,
                          // map,
                          // msgCount
                        ))
                    .toList(),
              )),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    if (!isConnected) {
                      await mqttConnection.mqttConnect(hospitalID);
                      mqttConnection
                          .subscribeTopic('/AmbulanceProject/$hospitalID/+');
                      mqttConnection.subscribeTopic(
                          'message/from/ambulance/$hospitalID/+');
                      mqttConnection.subscribeTopic('Stop/$hospitalID/+');
                      mqttConnection
                          .subscribeTopic('PatientData/$hospitalID/+');
                      mqttConnection.subscribeTopic('TransferPatient/+/+');
                      setupUpdatesListener();
                      setState(() {
                        isConnected = true;
                      });
                    }
                  },
                  child: const Text('Connect'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    if (isConnected) {
                      setState(() {
                        mqttConnection.disconnect();
                        isConnected = false;
                      });
                    }
                  },
                  child: const Text('Disconnect'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    mqttConnection.disconnect();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text('Logout'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    // mqttConnection.disconnect();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Admin(hospitals: hospitals)));
                  },
                  child: const Text('Admin'),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            padding: const EdgeInsets.all(5),
            child: isConnected
                ? const Text(
                    'Connected to AWS',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )
                : const Text(
                    'Not Connected',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
          )
        ]),
      ),
    );
  }
}

// class MsgCount {
//   late int count;
// }
