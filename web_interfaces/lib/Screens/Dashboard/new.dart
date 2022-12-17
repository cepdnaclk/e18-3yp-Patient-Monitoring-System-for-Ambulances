import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Dashboard/contact.dart';
import 'patient_info.dart';

//import 'contact.dart'
class NewFunc extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<NewFunc> {
  final List<Contact> names = <Contact>[];
  //final List<int> msgCount = <int>[];

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addItemToList() {
    setState(() {
      //names.insert(0, nameController.text);
      names.add(Contact(
          name: nameController.text, contact: descriptionController.text));

      // msgCount.insert(0, 0);
    });
  }

  String text = '';
  String pdescription = '';
  //Contact contact = new Contact(name: pname, contact: pdescription);
  //var contact = new Contact (name,con);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Patient Cards'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Patient Number',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Patient Details',
              ),
            ),
          ),
          ButtonTheme(
            minWidth: 50.0,
            height: 20.0,
            child: ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                addItemToList();
              },
            ),
          ),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: names.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.deepPurpleAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ListTile(
                          title: Text(
                              '${names[index].name}\n${names[index].contact}'),
                          trailing: Container(
                            width: 300,
                            child: Row(
                              children: [
                                Expanded(
                                    child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => SimpleDialog(
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return SignUpScreen();
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Text('ViewDetails'))
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.info))),
                                Expanded(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            names.removeAt(index);
                                          });
                                        },
                                        icon: Icon(Icons.delete)))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }))
        ]));
  }
}
