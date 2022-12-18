import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:ambulance_tracking/pages/NewPatient.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ambulance_tracking/pages/Patient.dart';
import 'package:ambulance_tracking/pages/PatientDetails.dart';


final MqttServerClient client = MqttServerClient('a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com', '');
//String s = '';

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
// void _onMessage(List<MqttReceivedMessage> event) {
//   final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
//   final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//   log("message from AWS $message");
//   setState(() {
//     str = message;
//   });
// }
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

  String topic = 'patient/data';
  client.subscribe(topic, MqttQos.atMostOnce);
  client.subscribe(topic, MqttQos.atMostOnce);
  // const pubTopic = 'topic/test';
  // final builder = MqttClientPayloadBuilder();
  //builder.addString(jsonEncode(patient));
  //client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
    //ss = pt;
    print(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });
}

