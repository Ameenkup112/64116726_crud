import 'package:flutter/material.dart';
import 'screen/Home.dart';
import 'screen/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
      },
    );
  }
}
