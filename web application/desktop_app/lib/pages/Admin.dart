import 'dart:async';
import 'package:flutter/material.dart';
import 'package:desktop_app/people/Hospital.dart';
import 'package:desktop_app/api/ApiConnection.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter_map/flutter_map.dart';

// ignore: must_be_immutable
class Admin extends StatefulWidget {
  List<Hospital> hospitals;
  Admin({super.key, required this.hospitals});

  @override
  // ignore: no_logic_in_create_state
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
  TextEditingController hospitalLatController = TextEditingController();
  TextEditingController hospitalLongController = TextEditingController();
  TextEditingController hospitalContactController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController removeHospitalIDController = TextEditingController();
  TextEditingController removeUserIDController = TextEditingController();
  HttpLoader httpLoader = HttpLoader();
  late Hospital selectedHospital;
  late List<Hospital> findHospitals;

  @override
  void initState() {
    super.initState();
    selectedHospital =
        hospitals[hospitals.indexWhere((element) => element.id == 'H001')];
    findHospitals = hospitals;

    Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Widget cardTemplate(Hospital h) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedHospital = h;
        });
      },
      child: Card(
        margin: const EdgeInsets.all(7),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'ID: ${h.id}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
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
      ),
    );
  }

  Widget hospitalMap() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          // color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(double.parse(selectedHospital.lat),
              double.parse(selectedHospital.long)),
          zoom: 7,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: latLng.LatLng(double.parse(selectedHospital.lat),
                    double.parse(selectedHospital.long)),
                width: 80,
                height: 80,
                builder: (context) => const Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 209, 27, 14),
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void runFilter(String enterdKeyword) {
    List<Hospital> results = [];
    if (enterdKeyword.isEmpty) {
      results = hospitals;
    } else {
      results = hospitals
          .where((hospital) =>
              hospital.name.toLowerCase().contains(enterdKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      findHospitals = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Expanded(
                flex: 1,
                child: Column(children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: _formKey1,
                            child: Column(children: <Widget>[
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Hospital ID';
                                  }
                                  return null;
                                },
                                controller: hospitalIDController,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  labelText: 'Hospital ID',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Hospital Name';
                                  }
                                  return null;
                                },
                                controller: hospitalNameController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: 'Hospital Name',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10)),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Contact No';
                                  }
                                  return null;
                                },
                                controller: hospitalContactController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: 'Contact No',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10)),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Lattitude';
                                  }
                                  return null;
                                },
                                controller: hospitalLatController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: 'Lattitude',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10)),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Longitude';
                                  }
                                  return null;
                                },
                                controller: hospitalLongController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: 'Longitude',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10)),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 20.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          192, 76, 175, 79)),
                                  onPressed: () async {
                                    // setState(() async {});
                                    if (_formKey1.currentState!.validate()) {
                                      await httpLoader.putHospital(
                                          hospitalIDController.text,
                                          hospitalNameController.text,
                                          hospitalLatController.text,
                                          hospitalLongController.text,
                                          hospitalContactController.text);

                                      List<Hospital> list =
                                          await httpLoader.getHospitals();

                                      for (int i = 0;
                                          i < hospitals.length;
                                          i++) {
                                        hospitals[i] = list[i];
                                      }
                                      hospitals.add(list.last);

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'New Hospital Added'),
                                              content: Text(
                                                  'Succeccfully added ${hospitalIDController.text}-${hospitalNameController.text} to the System'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    hospitalIDController
                                                        .clear();
                                                    hospitalNameController
                                                        .clear();
                                                    hospitalContactController
                                                        .clear();
                                                    hospitalLatController
                                                        .clear();
                                                    hospitalLongController
                                                        .clear();
                                                    Navigator.pop(
                                                        context, 'OK');
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          });
                                    }
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
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Hospital ID';
                                  }
                                  return null;
                                },
                                controller: removeHospitalIDController,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  labelText: 'Hospital ID',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 20.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        228, 243, 110, 100),
                                  ),
                                  onPressed: () {
                                    if (_formKey3.currentState!.validate()) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Remove Hospital'),
                                              content: Text(
                                                  'Are you sure you want to remove ${removeHospitalIDController.text} from the System'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, 'Cancel');
                                                    removeHospitalIDController
                                                        .clear();
                                                  },
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(
                                                        context, 'OK');

                                                    await httpLoader.deleteHospital(
                                                        removeHospitalIDController
                                                            .text);
                                                    List<Hospital> list =
                                                        await httpLoader
                                                            .getHospitals();
                                                    for (int i = 0;
                                                        i < list.length;
                                                        i++) {
                                                      hospitals[i] = list[i];
                                                    }
                                                    hospitals.removeLast();

                                                    removeHospitalIDController
                                                        .clear();
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            );
                                          });
                                    }
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
                ])),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter User ID';
                                    }
                                    return null;
                                  },
                                  controller: userIDController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: 'User ID',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 30.0),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Password';
                                    }
                                    return null;
                                  },
                                  controller: userPasswordController,
                                  decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelText: 'Password',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10)),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      if (_formKey2.currentState!.validate()) {
                                        await httpLoader.putUser(
                                            userIDController.text,
                                            userPasswordController.text);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'New User Added'),
                                                content: Text(
                                                    'Succeccfully added ${userIDController.text} to the System'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      userIDController.clear();
                                                      userPasswordController
                                                          .clear();
                                                      Navigator.pop(
                                                          context, 'OK');
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            });
                                      }
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
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter User ID';
                                    }
                                    return null;
                                  },
                                  controller: removeUserIDController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: 'User ID',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          228, 243, 110, 100),
                                    ),
                                    onPressed: () {
                                      if (_formKey4.currentState!.validate()) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Remove User'),
                                                content: Text(
                                                    'Are you sure you want to remove ${removeUserIDController.text} from the System'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'Cancel');
                                                      removeUserIDController
                                                          .clear();
                                                    },
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(
                                                          context, 'OK');

                                                      await httpLoader.deleteUser(
                                                          removeUserIDController
                                                              .text);

                                                      removeUserIDController
                                                          .clear();
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              );
                                            });
                                      }
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
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                              child: Row(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  Text(
                                    '${selectedHospital.id}: Location',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.17,
                            child: hospitalMap(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                    height: MediaQuery.of(context).size.height * 0.9,
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
                                    'Hospitals',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              onChanged: (value) => runFilter(value),
                              decoration: const InputDecoration(
                                  labelText: 'Search',
                                  fillColor: Colors.white,
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  suffixIcon: Icon(Icons.search)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                              children: findHospitals
                                  .map((e) => cardTemplate(e))
                                  .toList()),
                        ],
                      ),
                    ))),
          ]),
        ),
      ),
    );
  }
}
