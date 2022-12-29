import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:html';

import 'package:ambulance_tracking/pages/Conn.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ambulance_tracking/pages/Message.dart';
// import 'package:ambulance_tracking/pages/PatientDetails.dart';
// import 'package:ambulance_tracking/pages/MessageList.dart';
// import 'Conn.dart';
// import 'Conn.dart';

class Chat extends StatefulWidget {
  final Connection connect;
  final List<Message> mess;
  late int msgCount;
  final String hospitalID;
  final String deviceID;
  Chat(this.connect, this.mess, this.msgCount, this.hospitalID, this.deviceID);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  // late String str = 'none';
  late bool isFirstClick;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    // str = 'none';
    print(widget.mess);

    // message.addAll(widget.mess);
    // widget.mess.clear();
    // isFirstClick = true;

    //updateMsg();
    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {
        widget.msgCount = 0;
        //widget.mess.add(Message('test', DateTime.now(), true));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: <Widget>[
          Expanded(
              child: GroupedListView<Message, DateTime>(
            padding: const EdgeInsets.all(8),
            elements: widget.mess,
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
            padding: const EdgeInsets.all(5.0),
            // color: Colors.grey,
            child: Row(children: <Widget>[
              SizedBox(
                width: 315,
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      contentPadding: EdgeInsets.all(15),
                      hintText: 'Text Message'),
                  controller: messageController,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                // color: Colors.red,
                padding: const EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: IconButton(
                    color: Colors.blueAccent,
                    icon: const Icon(Icons.send, size: 45),
                    //padding: EdgeInsets.all(10),
                    onPressed: () {
                      final msg =
                          Message(messageController.text, DateTime.now(), true);
                      // if(isFirstClick){
                      //   setupUpdatesListenerForChat();
                      // }
                      setState(() {
                        isFirstClick = false;
                        widget.mess.add(msg);
                        widget.connect.publishMsg(
                            'message/from/ambulance/${widget.hospitalID}/${widget.deviceID}',
                            '{"message":"${msg.text}"}');
                      });
                      messageController.clear();
                    },
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
