import 'package:flutter/material.dart';
import 'package:desktop_app/people/Hospital.dart';
import 'package:grouped_list/grouped_list.dart';

class Admin extends StatefulWidget {
  List<Hospital> hospitals;
  Admin({super.key, required this.hospitals});

  @override
  State<Admin> createState() => _AdminState(hospitals);
}

class _AdminState extends State<Admin> {
  List<Hospital> hospitals;
  _AdminState(this.hospitals);
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  TextEditingController hospitalIDController = TextEditingController();
  TextEditingController hospitalNameController = TextEditingController();
  TextEditingController userIDController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController removeHospitalIDController = TextEditingController();
  TextEditingController removeUserIDController = TextEditingController();

  Widget cardTemplate(Hospital h) {
    return Card(
      margin: EdgeInsets.all(7),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'ID: ${h.id}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Name: ${h.name}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Contact Num: ${h.contactNumber}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              // borderRadius: BorderRadius.all(Radius.circular(20.0)),
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment(0.8, 1),
              //   colors: <Color>[
              //     Color.fromARGB(255, 86, 177, 251),
              //     Color.fromARGB(255, 3, 141, 255),
              //   ],
              //   tileMode: TileMode.mirror,
              // ),
              ),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  // margin: EdgeInsets.only(left: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment(0.5, 1.2),
                                      colors: <Color>[
                                        Color.fromARGB(255, 86, 177, 251),
                                        Color.fromARGB(255, 3, 141, 255),
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(20.0),
                                                  topLeft:
                                                      Radius.circular(20.0)),
                                              color:
                                                  Color.fromARGB(30, 0, 0, 0)),
                                          padding: const EdgeInsets.all(5),
                                          // color: Colors.white,
                                          child: Row(
                                            children: const [
                                              Expanded(child: SizedBox()),
                                              Text(
                                                'Add New Hospital',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Expanded(child: SizedBox()),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Form(
                                          key: _formKey1,
                                          child: Column(children: <Widget>[
                                            TextFormField(
                                              // validator: (value) {
                                              //   if (value == null || value.isEmpty) {
                                              //     return 'Please enter some text';
                                              //   }
                                              //   return null;
                                              // },
                                              controller: hospitalIDController,

                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                labelText: 'Hospital ID',
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(height: 30.0),
                                            TextFormField(
                                              // validator: (value) {
                                              //   if (value == null || value.isEmpty) {
                                              //     return 'Please enter some text';
                                              //   }
                                              //   return null;
                                              // },
                                              controller:
                                                  hospitalNameController,
                                              decoration: const InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  labelText: 'Hospital Name',
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 10)),
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            192, 76, 175, 79)),
                                                onPressed: () async {
                                                  if (_formKey1.currentState!
                                                      .validate()) {}
                                                },
                                                child: const Text('Submit'),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  // margin: EdgeInsets.only(left: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment(1.5, 0.2),
                                      colors: <Color>[
                                        Color.fromARGB(255, 3, 141, 255),
                                        Color.fromARGB(255, 86, 177, 251),
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                topLeft: Radius.circular(20.0)),
                                            color: Color.fromARGB(30, 0, 0, 0),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          // color: Colors.white,
                                          child: Row(
                                            children: const [
                                              Expanded(child: SizedBox()),
                                              Text(
                                                'Add New User',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Expanded(child: SizedBox()),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Form(
                                          key: _formKey2,
                                          child: Column(children: <Widget>[
                                            TextFormField(
                                              // validator: (value) {
                                              //   if (value == null || value.isEmpty) {
                                              //     return 'Please enter some text';
                                              //   }
                                              //   return null;
                                              // },
                                              controller: userIDController,

                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                labelText: 'User ID',
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10,
                                                ),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(height: 30.0),
                                            TextFormField(
                                              // validator: (value) {
                                              //   if (value == null || value.isEmpty) {
                                              //     return 'Please enter some text';
                                              //   }
                                              //   return null;
                                              // },
                                              controller: userNameController,
                                              decoration: const InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  labelText: 'User Name',
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 10)),
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green),
                                                onPressed: () async {
                                                  if (_formKey2.currentState!
                                                      .validate()) {}
                                                },
                                                child: const Text('Submit'),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ///////////////////////////////////////////////////////////////////////
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  // margin: EdgeInsets.only(left: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment(0.5, 1.2),
                                      colors: <Color>[
                                        Color.fromARGB(255, 86, 177, 251),
                                        Color.fromARGB(255, 3, 141, 255),
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                topLeft: Radius.circular(20.0)),
                                            color: Color.fromARGB(30, 0, 0, 0),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          // color: Colors.white,
                                          child: Row(
                                            children: const [
                                              Expanded(child: SizedBox()),
                                              Text(
                                                'Remove Hospital',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Expanded(child: SizedBox()),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Form(
                                          key: _formKey3,
                                          child: Column(children: <Widget>[
                                            TextFormField(
                                              // validator: (value) {
                                              //   if (value == null || value.isEmpty) {
                                              //     return 'Please enter some text';
                                              //   }
                                              //   return null;
                                              // },
                                              controller:
                                                  removeHospitalIDController,

                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                labelText: 'Hospital ID',
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          228, 243, 110, 100),
                                                ),
                                                onPressed: () async {
                                                  if (_formKey3.currentState!
                                                      .validate()) {}
                                                },
                                                child: const Text('Remove'),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  // margin: EdgeInsets.only(left: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment(1.5, 0.2),
                                      colors: <Color>[
                                        Color.fromARGB(255, 3, 141, 255),
                                        Color.fromARGB(255, 86, 177, 251),
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                topLeft: Radius.circular(20.0)),
                                            color: Color.fromARGB(30, 0, 0, 0),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          // color: Colors.white,
                                          child: Row(
                                            children: const [
                                              Expanded(child: SizedBox()),
                                              Text(
                                                'Remove User',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Expanded(child: SizedBox()),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Form(
                                          key: _formKey4,
                                          child: Column(children: <Widget>[
                                            TextFormField(
                                              // validator: (value) {
                                              //   if (value == null || value.isEmpty) {
                                              //     return 'Please enter some text';
                                              //   }
                                              //   return null;
                                              // },
                                              controller:
                                                  removeUserIDController,

                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                labelText: 'User ID',
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            // const SizedBox(height: 30.0),

                                            const SizedBox(height: 20.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          228, 243, 110, 100),
                                                ),
                                                onPressed: () async {
                                                  if (_formKey4.currentState!
                                                      .validate()) {}
                                                },
                                                child: const Text('Remove'),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ////////////////////////////////////////////////////////////////
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                            // padding: EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment(0.5, 1.2),
                                colors: <Color>[
                                  Color.fromARGB(255, 86, 177, 251),
                                  Color.fromARGB(255, 3, 141, 255),
                                ],
                                tileMode: TileMode.mirror,
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * 2 / 3,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0)),
                                          color: Color.fromARGB(30, 0, 0, 0)),
                                      padding: const EdgeInsets.all(5),
                                      // color: Colors.white,
                                      child: Row(
                                        children: const [
                                          Expanded(child: SizedBox()),
                                          Text(
                                            'Add New Hospital',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Expanded(child: SizedBox()),
                                        ],
                                      )),
                                  Column(
                                      children: hospitals
                                          .map((e) => cardTemplate(e))
                                          .toList()),
                                ],
                              ),
                            )
                            // margin: EdgeInsets.on(value),
                            ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.amber,
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
