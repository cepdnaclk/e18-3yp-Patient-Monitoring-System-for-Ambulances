import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ambulance_tracking/pages/PatientDetails.dart';
import 'package:ambulance_tracking/pages/ApiConnection.dart';
import 'package:ambulance_tracking/users/Hospital.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  HttpLoader httpLoader = HttpLoader();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Do something here
        log("After clicking the Android Back Button");
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.health_and_safety,
                size: 40, color: Colors.white60),
            // leadingWidth: 60,
            title: const Text('Login'),
            titleTextStyle: TextStyle(
                fontSize: 30,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          body: Container(
            padding: const EdgeInsets.all(40.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Colors.lightBlueAccent,
                  Colors.blue,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                    ),
                    // height: 290,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          key: ValueKey('userFinder'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: userNameController,
                          decoration: const InputDecoration(
                              labelText: 'User ID',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10)),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 30.0),

                        TextFormField(
                          key: ValueKey("passwordFinder"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10)),
                          style: const TextStyle(fontSize: 20),
                        ),

                        //const SizedBox(height:1.0),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            key: ValueKey('loginBtnFinder'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String response = await httpLoader.httpGET(
                                    userNameController.text,
                                    passwordController.text);

                                List<Hospital> hospitals =
                                    await httpLoader.getHospitals();

                                if (!mounted) return;
                                if (response == '"True"') {
                                  // print('response worked');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewDetails(
                                              userNameController.text,
                                              hospitals)));
                                } else {
                                  // print('respose not work');
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Invalid Login'),
                                          content: Text(
                                              'Incorrect login details',
                                              key: ValueKey('wrongLoginText')),
                                          // content: response == '"False"'
                                          //     ? const Text('Incorrect Password')
                                          //     : const Text('Invalid User ID'),
                                          actions: <Widget>[
                                            TextButton(
                                              key: ValueKey('OKBtn'),
                                              onPressed: () {
                                                Navigator.pop(context, 'OK');
                                                passwordController.clear();
                                                userNameController.clear();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              }
                            },
                            child: const Text('Login'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
