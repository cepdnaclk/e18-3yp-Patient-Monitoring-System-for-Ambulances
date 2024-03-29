import 'dart:async';
// import 'dart:convert';
import 'dart:developer';
// import 'dart:html';
import 'dart:io';
// import 'dart:typed_data';
// import 'package:ndialog/ndialog.dart';
// import 'package:flutter/material.dart';
// import 'package:ambulance_tracking/pages/NewPatient.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:ambulance_tracking/pages/Patient.dart';
// import 'package:ambulance_tracking/pages/PatientDetails.dart';

class Connection {
  final MqttServerClient client = MqttServerClient(
      'a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com', '');
  void onConnected() {
    log("connection successful");
  }

  void onDisconnected() {
    log("client disconnected");
  }

  void pong() {
    log("ping invoked");
  }

  void disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String clientIdentifier) async {
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

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean();
    client.connectionMessage = connMess;

    await client.connect();

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      log("Connected to AWS");
    } else {
      return false;
    }

    return true;
  }

  void subscribeTopic(String topic) {
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void publishMsg(String topic, String msg) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    log(client.updates.toString());
    return client.updates;
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getStream() {
    log(client.updates.toString());
    return client.updates;
  }
}
