// import 'dart:convert';
// import 'package:ambulance_tracking/pages/Conn.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:ambulance_tracking/pages/Message.dart';
// class MessageList{
//
//   void setupUpdatesListenerForChat(Connection conn) {
//     conn
//         .getStream()!
//         .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//       final recMess = c![0].payload as MqttPublishMessage;
//       final pt =
//       MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//
//       message.add(Message.fromJson(jsonDecode(pt), DateTime.now().subtract(const Duration(minutes: 1)), false));
//
//       print('Chat: <${c[0].topic}> is $pt\n');
//     });
//   }
// }
// List<Message> message = [
//   Message('hi', DateTime.now().subtract(const Duration(minutes: 1)), true),
//   Message('hellooo', DateTime.now().subtract(const Duration(minutes: 1)), false),
//   Message('koomatheeeeee', DateTime.now().subtract(const Duration(minutes: 1)), true),
//   Message('hodaaaaaaaaaaaaaaaaaaaaaaaai', DateTime.now().subtract(const Duration(minutes: 1)), false),
//   Message('elaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', DateTime.now().subtract(const Duration(minutes: 1)), true)
// ];