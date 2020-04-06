import 'package:corona/classes.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class GlobalWidget extends StatefulWidget {
  final Global globalData;
  GlobalWidget({Key key, @required this.globalData}) : super(key: key);

  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<GlobalWidget> {
  int confirmed, recovered, death;
  Global myglobalData;
  Widget confirmedTile, recoveredTile, deathTile;
  bool showPieChart = false;
  List<charts.Series<Cases, String>> _casesData;

  @override
  initState() {
    super.initState();
    myglobalData = Global(widget.globalData.confirmed,
        widget.globalData.recovered, widget.globalData.deaths);
    _casesData = List<charts.Series<Cases, String>>();
  }

  Future<String> fetchData() async {
    confirmed = myglobalData.confirmed;
    recovered = myglobalData.recovered;
    death = myglobalData.deaths;
    // print(death);
    return death.toString();
  }

  switchgraphVisibility() {
    setState(() {
      showPieChart = !showPieChart;
    });
  }

  generateChart() {
    var pieData = [
      new Cases('Confirmed', confirmed),
      new Cases('Recovered', recovered),
      new Cases('Deaths', death)
    ];

    _casesData.add(
      charts.Series(
        domainFn: (Cases data, _) => data.type,
        measureFn: (Cases data, _) => data.number,
        id: 'Time spent',
        data: pieData,
        labelAccessorFn: (Cases row, _) => '${row.type}',
      ),
    );

    return charts.PieChart(
      _casesData,
      animate: true,
      animationDuration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget confirmedTile = FutureBuilder<String>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Container();
            break;
          case ConnectionState.waiting:
            return new CircularProgressIndicator();
            break;
          case ConnectionState.active:
            return new CircularProgressIndicator();
            break;
          case ConnectionState.done:
            return new GestureDetector(
                onTap: switchgraphVisibility,
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.blue,
                    borderRadius: new BorderRadius.circular(10.00),
                  ),
                  // color: Colors.blue,
                  margin: EdgeInsets.all(5.0),
                  height: 100.0,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$confirmed',
                          style:
                              TextStyle(fontSize: 25.00, color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Confirmed',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ));
            break;
          default:
            return Text('Error');
        }
      },
    );

    Widget recoveredTile = FutureBuilder<String>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Container();
            break;
          case ConnectionState.waiting:
            return new CircularProgressIndicator();
            break;
          case ConnectionState.active:
            return new CircularProgressIndicator();
            break;
          case ConnectionState.done:
            return new GestureDetector(
              onTap: switchgraphVisibility,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.circular(10.00),
                ),
                margin: EdgeInsets.all(5.0),
                height: 100.0,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '$recovered',
                        style: TextStyle(fontSize: 25.00, color: Colors.white),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Recovered',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
            break;
          default:
            return Text('Error');
        }
      },
    );

    Widget deathTile = FutureBuilder<String>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Container();
            break;
          case ConnectionState.waiting:
            return new CircularProgressIndicator();
            break;
          case ConnectionState.active:
            return new CircularProgressIndicator();
            break;
          case ConnectionState.done:
            return new GestureDetector(
                onTap: switchgraphVisibility,
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: new BorderRadius.circular(10.00),
                  ),
                  margin: EdgeInsets.all(5.0),
                  height: 100.0,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$death',
                          style:
                              TextStyle(fontSize: 25.00, color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Deaths',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ));
            break;
          default:
            return Text('Error');
        }
      },
    );

    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
           showPieChart ?  Container(child: generateChart()) : confirmedTile,
          showPieChart ? Container() : recoveredTile,
          showPieChart ? Container() : deathTile,
        ],
      ),
    );
  }
}

class Cases {
  final String type;
  final int number;
  Cases(this.type, this.number);
}