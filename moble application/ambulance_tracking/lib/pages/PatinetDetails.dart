import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:ambulance_tracking/pages/Connect.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ambulance_tracking/pages/Patient.dart';
String ss = '';
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
  final MqttServerClient client = MqttServerClient('a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com', '');
  late Patient patient;
  String str = '';
  late String deviceID;
  late int age;
  late String name;
  late String condition;
  late bool firstClick;
  late bool isNameChanged;
  late bool isAgeChanged;
  late bool isConditionChanged;

  Map<String, String> menuItems = {"Hospital1":"001", "Hospital2":"002", "Hospital3":"003"};
  //late List<String> hospitalList = [];
  late String selectedVal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // mqttConnect();

    patient = Patient.empty();
    deviceID = '';
    firstClick = true;
    isNameChanged = false;
    isAgeChanged = false;
    isConditionChanged = false;
    name = 'none';
    age = 0;
    condition = 'none';
    //menuItems = ['none'];
    //hospitalList = menuItems.keys.toList();
    selectedVal = menuItems.keys.toList()[0];
    //print(menuItems['Hospital1']);
    print(selectedVal);

    //print(hospitalList);
    //selectedVal = hospitalList[0];
  }

  // Future<void> getMessage() async{
  //   client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
  //     final recMess = c![0].payload as MqttPublishMessage;
  //     final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
  //     print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  //     setState(() {
  //       str = pt;
  //     });
  //     print("heloooooooo   $str");
  //   });
  // }

  void onConnected(){
    log("connection successful");
  }
  void onDisconnected(){
    log("client disconnected");
  }

  void pong(){
    log("ping invoked");
  }

  _connect(){

  }
  _disconnect(){
    client.disconnect();
  }
  void mqttConnect() async{
    log("Connecting");

    ByteData rootCA = await rootBundle.load('asserts/certs/AmazonRootCA1.pem');
    ByteData deviceCert = await rootBundle.load('asserts/certs/2.crt');
    ByteData privateKey = await rootBundle.load('asserts/certs/1.key');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asInt8List());
    context.useCertificateChainBytes(deviceCert.buffer.asInt8List());
    context.usePrivateKeyBytes(privateKey.buffer.asInt8List());

    client.securityContext = context;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    final MqttConnectMessage connMess = MqttConnectMessage().withClientIdentifier('android').startClean();
    client.connectionMessage = connMess;

    await client.connect();

    if(client.connectionStatus!.state == MqttConnectionState.connected){
      log("Connected to AWS");
    }else{
      _disconnect();
    }

    String topic = 'Device_$deviceID';
    String pubTopic = '/AmbulanceProject/Hospital_${menuItems[selectedVal]}/$deviceID';
    const hosTopic = 'hospital/data';

    client.subscribe(pubTopic, MqttQos.atMostOnce);
    client.subscribe(hosTopic, MqttQos.atMostOnce);
    //client.subscribe(pubTopic, MqttQos.atMostOnce);

    final builder = MqttClientPayloadBuilder();
    builder.addString('start:${menuItems[selectedVal]}');
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
      setState(() {
        str = pt.toString();
        // Map<String, dynamic> json = jsonDecode(pt);
        //patient.fromJson(jsonDecode(pt));
        patient = Patient.fromJson(jsonDecode(pt));
        log(patient.toString());
      });
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
    //print(str);

  }

  Widget cardTemplate(String parameterName, double parameterValue, double maxValue){
    return Card(
      clipBehavior: Clip.antiAlias,
      color:  maxValue >= parameterValue ? Colors.blue[100] : Colors.red[200],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              // color: Colors.cyan,
              child: Text(parameterName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            const SizedBox(height:20.0),
            Text(parameterValue.toString(),
               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)
            )

          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hi'),
      ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10.0),
                    height: 550,
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
                          decoration: const InputDecoration(hintText: 'Device ID'),
                        ),
                        const SizedBox(height:30.0),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            setState(() {
                              if ((value == null || value.isEmpty) && !isNameChanged) {
                                name = 'none';
                              }else{
                                name = nameController.text;
                                isNameChanged = true;
                              }
                            });
                            return null;
                          },
                          decoration: const InputDecoration(hintText: 'Name'),
                        ),
                        const SizedBox(height:30.0),
                        TextFormField(
                          controller: ageController,
                          validator: (value) {
                            setState(() {
                              if ((value == null || value.isEmpty) && !isAgeChanged) {
                                age = 0;
                              }else{
                                age = int.parse(ageController.text);
                                isAgeChanged = true;
                              }
                            });
                            return null;
                          },
                          decoration: const InputDecoration(hintText: 'Age'),
                        ),
                        const SizedBox(height:30.0),
                        TextFormField(
                          // autofocus: false,
                          // initialValue: 'test',
                          controller: conditionController,
                          validator: (value) {
                            setState(() {
                              if ((value == null || value.isEmpty) && !isConditionChanged) {
                                //isConditionChanged = false;
                                condition = 'none';
                              }else{
                                condition = conditionController.text;
                                isConditionChanged = true;
                              }
                            });
                            return null;
                          },
                          decoration: const InputDecoration(hintText: 'Condition'),
                        ),
                        const SizedBox(height:30.0),
                        //hospital details
                        Container(
                            alignment: Alignment.topLeft,
                            width: 1000,
                            // color:  Colors.blue,
                            //padding: const EdgeInsets.all(30.0),
                            //margin: const EdgeInsets.all(10.0),
                            child:Column(
                                children: <Widget>[
                                  DropdownButton(
                                      value: selectedVal,
                                      items: menuItems.keys.toList().map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(),
                                      onChanged: (value){
                                        setState(() {
                                          selectedVal = value as String;
                                        });
                                      }
                                  )
                                ]
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: (){
                              // setState(() {
                              //   clickCount += 1;
                              // });
                              log('clicked=$firstClick');
                              if(_formKey.currentState!.validate() && firstClick){
                                setState(() {
                                  firstClick = false;
                                });
                                deviceID = deviceIDController.text;
                                mqttConnect();
                              }
                              log('condition added:$isConditionChanged');
                              // setState(() {
                              //   name = nameController.text == ''? 'none' : nameController.text;
                              //   age = age == 0? age : int.parse(ageController.text);
                              //   //condition = isConditionChanged ? conditionController.text : 'none';
                              //   log(name);
                              //   log(condition);
                              //   log(age.toString());
                              //   log(deviceID.toString());
                              //   log(patient.toString());
                              // });
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
                  height: 340,
                  width: 500,

                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    children: <Widget>[
                      cardTemplate("Temperature", patient.temperature, 37.0),
                      cardTemplate("Heart Rate", patient.heartRate, 100.0),
                      cardTemplate("Pulse Rate", patient.pulseRate, 10.0),
                      cardTemplate("Oxygen Sat.", patient.oxygenSaturation, 20.0)
                    ],
                  ),
                )

              ],
            ),
          ),
        )
    );
  }
}
