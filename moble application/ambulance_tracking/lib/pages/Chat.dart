import 'dart:convert';
import 'dart:developer';
// import 'dart:html';

import 'package:ambulance_tracking/pages/Conn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ambulance_tracking/pages/Message.dart';
import 'package:ambulance_tracking/pages/PatientDetails.dart';
// import 'package:ambulance_tracking/pages/MessageList.dart';
import 'Conn.dart';
import 'Conn.dart';

class Chat extends StatefulWidget {
  final Connection connect;
  final List<Message> mess;
  late int msgCount;
  Chat(this.connect, this.mess, this.msgCount);

  @override
  State<Chat> createState() => _ChatState();

}

class _ChatState extends State<Chat> {

  TextEditingController messageController = TextEditingController();
  late String str = 'none';
  late bool isFirstClick;
  // Connection connect;
  //_ChatState(this.connect);
  //Connection conn =
  
  //_ChatState(Connection connect); Connection();
  // static List<Message> message = [
  //   Message('hi', DateTime.now().subtract(const Duration(minutes: 1)), true),
  //   Message('hellooo', DateTime.now().subtract(const Duration(minutes: 1)), false),
  //   Message('koomatheeeeee', DateTime.now().subtract(const Duration(minutes: 1)), true),
  //   Message('hodaaaaaaaaaaaaaaaaaaaaaaaai', DateTime.now().subtract(const Duration(minutes: 1)), false),
  //   Message('elaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', DateTime.now().subtract(const Duration(minutes: 1)), true)
  // ];
  //static List<Message> message = [];
  //late int i;
  //List _items = [];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    str = 'none';
    print(widget.mess);

    // message.addAll(widget.mess);
    // widget.mess.clear();
    isFirstClick = true;
    widget.msgCount = 0;
  }
  void setupUpdatesListenerForChat() {
    //final File file = File('asserts/files/test.json');

    widget.connect
        .getStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      if (!mounted) {
        return;
      }
      setState((){
        widget.mess.removeLast();
        widget.mess.add(Message.fromJson(jsonDecode(pt), DateTime.now().subtract(const Duration(minutes: 1)), false));
      });
      print('Chat: <${c[0].topic}> is $pt\n');
    });
  }
  // Future<void> readJson() async {
  //   final String response = await rootBundle.loadString('asserts/files/test.json');
  //   final data = await json.decode(response);
  //   log(response);
  //   setState(() {
  //     //message.add(Message.fromJson(jsonDecode(response), DateTime.now().subtract(const Duration(minutes: 1)), false));
  //     _items = data["items"];
  //     print(_items);
  //     for(int i = 0; i < _items.length; i++){
  //       log(_items[i]["message"]);
  //       message.add(Message(_items[i]["message"], DateTime.now().subtract(const Duration(minutes: 1)), false));
  //     }
  //   });
  // }


  // Future<void> writeJson(String s) async {
  //   final String response = await rootBundle.loadString('asserts/files/test.json');
  //   final data = await json.decode(response);
  //   log(response);
  //   setState(() {
  //     //message.add(Message.fromJson(jsonDecode(response), DateTime.now().subtract(const Duration(minutes: 1)), false));
  //     _items = data["items"];
  //     _items.add(s);
  //     print(_items);
  //     for(int i = 0; i < _items.length; i++){
  //       log(_items[i]["message"]);
  //       message.add(Message(_items[i]["message"], DateTime.now().subtract(const Duration(minutes: 1)), false));
  //     }
  //   });
  // }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat')
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: GroupedListView<Message, DateTime>(
                  padding: const EdgeInsets.all(8),
                  elements: widget.mess,
                  groupBy: (message) => DateTime(2022),
                  groupHeaderBuilder: (Message message) => SizedBox(),
                  itemBuilder: (context, Message message) => Align(
                    alignment: message.isSentByMe? Alignment.centerRight:Alignment.centerLeft,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(message.text),
                      ),
                    ),
                  ),
                )
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              // color: Colors.grey,
              child:Row(
                  children: <Widget>[
                    SizedBox(
                      width: 310,
                      child: TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0))
                          ),
                        contentPadding: EdgeInsets.all(15),
                        hintText: 'type msg'
                      ),

                      controller: messageController,



                      // onSubmitted: (text){
                      //   // setupUpdatesListenerForChat();
                      //   final msg = Message(text, DateTime.now(), true);
                      //   setState(() {
                      //     message.add(msg);
                      //     widget.connect.publishMsg('chat/send/data', msg.text);
                      //   });
                      // },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: IconButton(
                          color: Colors.blueAccent,
                          icon: const Icon(Icons.send, size: 45),
                        //padding: EdgeInsets.all(10),
                        onPressed: (){
                          final msg = Message(messageController.text, DateTime.now(), true);
                          if(isFirstClick){
                            setupUpdatesListenerForChat();
                          }
                          setState(() {
                            isFirstClick = false;
                            widget.mess.add(msg);
                            widget.connect.publishMsg('chat/send/data', msg.text);
                          });
                        },
                      ),
                    )


                ]
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16.0),
            //   child: ElevatedButton(
            //
            //     onPressed: () async{
            //         //await connect.mqttConnect('001', '001');
            //       // widget.connect.subscribeTopic('chat/receive/data');
            //       setupUpdatesListenerForChat();
            //       // widget.connect.publishMsg('chat/send/data', 'hloo');
            //       //readJson();
            //       }, child: null,
            //
            //   ),
            // ),
            // Text(str)
          ],
        ),
      ),
    );
  }
}
