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
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  HttpLoader httpLoader = HttpLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
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
            // color: Colors.black.withOpacity(0.3),
            width: 400,
            height: 350,
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  TextFormField(
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: passwordController,
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
                              userNameController.text, passwordController.text);
                          if (!mounted) return;
                          if (response == '"True"') {
                            // print('response worked');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
                          } else {
                            // print('respose not work');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Invalid Login'),
                                    content: response == '"False"'
                                        ? const Text('Incorrect Password')
                                        : const Text('Invalid User ID'),
                                    actions: <Widget>[
                                      // TextButton(
                                      //   onPressed: () => Navigator.pop(context, 'Cancel'),
                                      //   child: const Text('Cancel'),
                                      // ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const Home()));
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
