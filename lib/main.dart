import 'package:flutter/material.dart';
import 'casesList.dart';
import 'chartPage.dart';
// import 'package:http/http.dart';
// import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CasesList(),
      ),
    );
  }
}
