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
  int currentIndex = 0;
  var _children = [CasesList(), ChartsPage()];
  changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _children[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: changeIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              title: Text('By date'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart), title: Text('Graphs')),
          ],
        ),
      ),
    );
  }
}
