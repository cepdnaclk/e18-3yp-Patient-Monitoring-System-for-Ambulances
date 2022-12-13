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
import 'package:ambulance_tracking/users/User.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}



class _LoginState extends State<Login> {

  final MqttServerClient client = MqttServerClient('a3rwyladencomq-ats.iot.ap-northeast-1.amazonaws.com', '');
  // String userName = '';
  // String password = '';
  String str = '';
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // void setStatus(String content){
  //   setState(() {
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
  // void _onMessage(List<MqttReceivedMessage> event) {
  //   final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
  //   final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
  //   log("message from AWS $message");
  //   setState(() {
  //     str = message;
  //   });
  // }
  void mqttConnect(User user) async{
    log("Connecting");

    ByteData rootCA = await rootBundle.load('asserts/certs/AmazonRootCA1.pem');
    ByteData deviceCert = await rootBundle.load('asserts/certs/53ade14b7cc137a040f4a51dda2de37cc94f16dbc0eaf69221ac238933a1d3d5-certificate.pem.crt');
    ByteData privateKey = await rootBundle.load('asserts/certs/53ade14b7cc137a040f4a51dda2de37cc94f16dbc0eaf69221ac238933a1d3d5-private.pem.key');

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

    String topic = 'user/${user.userID}';
    client.subscribe(topic, MqttQos.atMostOnce);
    client.subscribe(topic, MqttQos.atMostOnce);
    // const pubTopic = 'topic/test';
    final builder = MqttClientPayloadBuilder();
    builder.addString(user.toString());
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);

      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    // String name, password;

    return Scaffold(

        appBar: AppBar(
          title: const Text('App'),
        ),
        body: Container(
          //color: Colors.red,
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.blue,
                height: 400,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: userNameController,
                      decoration: const InputDecoration(hintText: 'User ID'),
                    ),
                    const SizedBox(height:30.0),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          // if (_formKey.currentState!.validate()) {
                          //   Navigator.push(context,
                          //       MaterialPageRoute(builder: (context) => const NewPatient())
                          //   );
                          // }
                          if (_formKey.currentState!.validate()){
                            log("conn");
                            User user = User(userNameController.text, passwordController.text);
                            log(user.toJson().toString());
                            // print(jsonEncode(user));
                            mqttConnect(user);
                          }


                        },
                        child: const Text('Submit'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );




  }
}
