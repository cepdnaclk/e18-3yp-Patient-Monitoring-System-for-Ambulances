import 'package:desktop_app/pages/Admin.dart';
import 'package:desktop_app/people/Hospital.dart';
import 'package:flutter/material.dart';
import 'package:desktop_app/api/ApiConnection.dart';
import 'package:desktop_app/pages/Home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController adminIDController = TextEditingController();
  TextEditingController adminpasswordController = TextEditingController();
  HttpLoader httpLoader = HttpLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Admin Login'),
      ),
      body: Container(
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
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            padding: const EdgeInsets.all(50),
            width: 400,
            height: 355,
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Hospital ID';
                      }
                      return null;
                    },
                    controller: adminIDController,
                    decoration: const InputDecoration(
                        labelText: 'Hospital ID',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: adminpasswordController,
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String response = await httpLoader.httpGET(
                              adminIDController.text,
                              adminpasswordController.text);
                          List<Hospital> hospitals =
                              await httpLoader.getHospitals();
                          if (!mounted) return;
                          if (response == '"True"') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Admin(hospitals: hospitals)));
                          } else {
                            // print('respose not work');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Invalid Login'),
                                    content: response == '"False"'
                                        ? const Text('Incorrect Password')
                                        : const Text('Invalid Admin ID'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
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
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
