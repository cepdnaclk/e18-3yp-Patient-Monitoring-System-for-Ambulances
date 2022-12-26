import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:desktop_app/chat/Message.dart';
import 'package:desktop_app/mqtt/MqttConnect.dart';
import 'package:grouped_list/grouped_list.dart';

class Chat extends StatefulWidget {
  String deviceID;
  String hospitalID;
  Map<String, List<Message>> mess;
  Connection connect;
  Chat(
      {super.key,
      required this.mess,
      required this.connect,
      required this.deviceID,
      required this.hospitalID});

  @override
  State<Chat> createState() => _ChatState(mess, connect, deviceID, hospitalID);
}

class _ChatState extends State<Chat> {
  String deviceID;
  String hospitalID;
  Map<String, List<Message>> mess;
  Connection connect;
  _ChatState(this.mess, this.connect, this.deviceID, this.hospitalID);

  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //mess.add(Message('text', DateTime.now(), true));
    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {
        print(
            '############################# ${mess[deviceID]} ###########################');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(31, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              height: 50,
              child: const Center(
                  child: Text(
                'Chat',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
            ))
          ],
        ),
        Expanded(
            child: GroupedListView<Message, DateTime>(
          padding: const EdgeInsets.all(8),
          elements: mess[deviceID] ?? [],
          groupBy: (message) => DateTime(2022),
          groupHeaderBuilder: (Message message) => const SizedBox(),
          itemBuilder: (context, Message message) => Align(
            alignment: message.isSentByMe
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(message.text),
              ),
            ),
          ),
        )),
        Container(
          padding: const EdgeInsets.all(10.0),
          // color: Colors.grey,
          child: SizedBox(
            child: TextField(
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Text Message'),
              controller: messageController,
              onSubmitted: (value) {
                final msg =
                    Message(messageController.text, DateTime.now(), true);
                setState(() {
                  if (mess[deviceID] == null) {
                    mess[deviceID] = [];
                  }
                  mess[deviceID]!.add(msg);
                  connect.publishMsg(
                      'message/from/hospital', '{"message":"${msg.text}"}');
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
