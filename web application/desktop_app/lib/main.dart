import 'package:flutter/material.dart';
import 'package:desktop_app/pages/Login.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(const MyApp());
  doWhenWindowReady(() {
    const initialSize = Size(1200, 700);
    appWindow.minSize = const Size(800, 700);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Ambulance Tracking';
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
