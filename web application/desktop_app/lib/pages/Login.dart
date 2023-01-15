import 'package:desktop_app/people/Hospital.dart';
import 'package:flutter/material.dart';
import 'package:desktop_app/api/ApiConnection.dart';
import 'package:desktop_app/pages/Home.dart';
import 'package:desktop_app/pages/Admin.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  TextEditingController hospitalIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController adminIDController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
  HttpLoader httpLoader = HttpLoader();

  late bool isObscure1;
  late bool isObscure2;

  @override
  void initState() {
    super.initState();
    isObscure1 = true;
    isObscure2 = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
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
        child: Row(
          children: [
            Expanded(child: SizedBox()),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color.fromARGB(255, 203, 240, 186),
                        Color.fromARGB(255, 169, 238, 181),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  padding: const EdgeInsets.only(
                      left: 50, right: 50, bottom: 50, top: 20),
                  width: 400,
                  // height: 355,
                  child: Column(
                    children: [
                      Text(
                        'User',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 2, 73, 132)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
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
                                  labelText: 'Hospital ID',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(
                                    Icons.verified_user,
                                    size: 20,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10)),
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
                              obscureText: isObscure1,
                              enableSuggestions: false,
                              autocorrect: false,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                      // hoverColor: null,
                                      highlightColor: null,
                                      icon: Icon(
                                        !isObscure1
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isObscure1 = !isObscure1;
                                        });
                                      }),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10)),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey1.currentState!.validate()) {
                                    String response = await httpLoader.httpGET(
                                        hospitalIDController.text,
                                        passwordController.text);
                                    List<Hospital> hospitals =
                                        await httpLoader.getHospitals();
                                    if (!mounted) return;
                                    if (response == '"True"') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home(
                                                  hospitalID:
                                                      hospitalIDController.text,
                                                  hospitals: hospitals)));
                                    } else {
                                      // print('respose not work');
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Invalid Login'),
                                              content: response == '"False"'
                                                  ? const Text(
                                                      'Incorrect Password')
                                                  : const Text(
                                                      'Invalid User ID'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, 'OK');
                                                    hospitalIDController
                                                        .clear();
                                                    passwordController.clear();
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
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 40,
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color.fromARGB(255, 239, 240, 186),
                        Color.fromARGB(255, 229, 236, 146),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      left: 50, right: 50, bottom: 50, top: 20),
                  width: 400,
                  // height: 400,
                  child: Column(
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 2, 73, 132)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Form(
                          key: _formKey2,
                          child: Column(children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Admin ID';
                                }
                                return null;
                              },
                              controller: adminIDController,
                              decoration: const InputDecoration(
                                  labelText: 'Admin ID',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(
                                    Icons.admin_panel_settings,
                                    size: 20,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10)),
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
                              obscureText: isObscure2,
                              enableSuggestions: false,
                              autocorrect: false,
                              controller: adminPasswordController,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                      // hoverColor: null,
                                      highlightColor: null,
                                      icon: Icon(
                                        !isObscure2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isObscure2 = !isObscure2;
                                        });
                                      }),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10)),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey2.currentState!.validate()) {
                                    List<Hospital> hospitals =
                                        await httpLoader.getHospitals();
                                    String response = await httpLoader.httpGET(
                                        adminIDController.text,
                                        adminPasswordController.text);

                                    if (!mounted) return;
                                    if (response == '"True"') {
                                      adminIDController.clear();
                                      adminPasswordController.clear();
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
                                              title:
                                                  const Text('Invalid Login'),
                                              content: response == '"False"'
                                                  ? const Text(
                                                      'Incorrect Password')
                                                  : const Text(
                                                      'Invalid Admin ID'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, 'OK');

                                                    adminIDController.clear();
                                                    adminPasswordController
                                                        .clear();
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
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
