import 'package:flutter/material.dart';
import 'package:corona/national.dart';
import 'package:corona/global.dart';
import 'classes.dart';

class MyApp extends StatefulWidget {
  final AvailableData jsonData;
  MyApp({Key key, @required this.jsonData}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  List<Widget> _children;

  @override
  initState() {
    super.initState();
    _children = [
      GlobalWidget(globalData: widget.jsonData.global),
      CountryData(entireJsonResponse: widget.jsonData.national),
    ];
  }

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
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.map), title: Text('Global')),
            BottomNavigationBarItem(
                icon: new Icon(Icons.location_on), title: Text('National')),
          ],
          onTap: changeIndex,
        ),
      ),
    );
  }
}
