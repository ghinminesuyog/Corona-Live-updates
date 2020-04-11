import 'package:corona/classes.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class GlobalWidget extends StatefulWidget {
  final GlobalPieData globalPieData;
  final globalGraphData;
  GlobalWidget(
      {Key key, @required this.globalPieData, @required this.globalGraphData})
      : super(key: key);

  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<GlobalWidget> {
  int confirmed, recovered, death;
  GlobalPieData myglobalPieData;
  Widget confirmedTile, recoveredTile, deathTile;
  bool showPieChart = false;
  List<charts.Series<Cases, String>> _casesData;
  List<charts.Series<TimeSeries, DateTime>> _casesDateGraph;
  List<charts.Series<TimeSeries, DateTime>> _confirmedDateGraph;
  List<charts.Series<TimeSeries, DateTime>> _recoveredDateGraph;
  List<charts.Series<TimeSeries, DateTime>> _deathDateGraph;

  @override
  initState() {
    super.initState();
    myglobalPieData = GlobalPieData(widget.globalPieData.confirmed,
        widget.globalPieData.recovered, widget.globalPieData.deaths);

    _casesData = List<charts.Series<Cases, String>>();
    _casesDateGraph = List<charts.Series<TimeSeries, DateTime>>();
    _confirmedDateGraph = List<charts.Series<TimeSeries, DateTime>>();
    _recoveredDateGraph = List<charts.Series<TimeSeries, DateTime>>();
    _deathDateGraph = List<charts.Series<TimeSeries, DateTime>>();
  }

  Future<String> fetchData() async {
    recovered = myglobalPieData.recovered;
    death = myglobalPieData.deaths;
    confirmed = myglobalPieData.confirmed - recovered - death;

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
      new Cases(
          'Confirmed', confirmed, charts.ColorUtil.fromDartColor(Colors.blue)),
      new Cases(
          'Recovered', recovered, charts.ColorUtil.fromDartColor(Colors.green)),
      new Cases('Deaths', death, charts.ColorUtil.fromDartColor(Colors.red))
    ];

    _casesData.add(
      charts.Series(
        domainFn: (Cases data, _) => data.type,
        measureFn: (Cases data, _) => data.number,
        colorFn: (Cases data, _) => data.colour,
        id: 'Cases',
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


    Widget confirmedChart() {
      List<TimeSeries> _confirmedList = [];

      var jsonData = widget.globalGraphData;
      Map res = jsonData['result'];

      var dates = (res.keys).toList();

      for (int i = 0; i < dates.length; i++) {
        String date = dates[i];

        var dateParts = date.split('-');
        int yr = int.parse(dateParts[0]);
        int mnth = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);

        DateTime constrDate = DateTime(yr, mnth, day);

        var dateResult = res[constrDate];

        int confirmed = dateResult['confirmed'];

        _confirmedList.add(
          TimeSeries(
            constrDate,
            confirmed,
            charts.ColorUtil.fromDartColor(Colors.blue),
          ),
        );
      }

      _confirmedDateGraph.add(
        charts.Series(
            id: 'Confirmed',
            data: _confirmedList,
            measureFn: (TimeSeries data, _) => data.count,
            domainFn: (TimeSeries data, _) => data.date,
            colorFn: (TimeSeries data, _) => data.colour),
      );
      return charts.TimeSeriesChart(
        _confirmedDateGraph,
      );
    }
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
                child: Column(children: [
                  // SizedBox(height: 50),
                  Container(
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
                        Text(
                          '$confirmed',
                          style:
                              TextStyle(fontSize: 20.00, color: Colors.white),
                        ),
                        Text(
                          'Confirmed',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ]));
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
                    Text(
                      '$recovered',
                      style: TextStyle(fontSize: 20.00, color: Colors.white),
                    ),
                    Text(
                      'Recovered',
                      style: TextStyle(color: Colors.white),
                    ),
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
                      Text(
                        '$death',
                        style: TextStyle(fontSize: 20.00, color: Colors.white),
                      ),
                      Text(
                        'Deaths',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ));
            break;
          default:
            return Text('Error');
        }
      },
    );


    Widget generateDateTimeChart() {
      List<TimeSeries> _confirmedList = [];
      List<TimeSeries> _recoveredList = [];
      List<TimeSeries> _deathList = [];

      var jsonData = widget.globalGraphData;
      Map res = jsonData['result'];

      var dates = (res.keys).toList();

      for (int i = 0; i < dates.length; i++) {
        String date = dates[i];

        var dateParts = date.split('-');
        int yr = int.parse(dateParts[0]);
        int mnth = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);

        DateTime constDate = DateTime(yr, mnth, day);

        var dateResult = res[date];

        int confirmed = dateResult['confirmed'];
        _confirmedList.add(TimeSeries(
            constDate, confirmed, charts.ColorUtil.fromDartColor(Colors.blue)));

        int recovered = dateResult['recovered'];
        _recoveredList.add(TimeSeries(constDate, recovered,
            charts.ColorUtil.fromDartColor(Colors.green)));
        int deaths = dateResult['deaths'];
        _deathList.add(TimeSeries(
            constDate, deaths, charts.ColorUtil.fromDartColor(Colors.red)));
      }

      _casesDateGraph.add(
        charts.Series(
            data: _confirmedList,
            measureFn: (TimeSeries data, _) => data.count,
            domainFn: (TimeSeries data, _) => data.date,
            colorFn: (TimeSeries data, _) => data.colour,
            id: 'Confirmed'),
      );
      _casesDateGraph.add(
        charts.Series(
            data: _recoveredList,
            measureFn: (TimeSeries data, _) => data.count,
            domainFn: (TimeSeries data, _) => data.date,
            colorFn: (TimeSeries data, _) => data.colour,
            id: 'Recovered'),
      );
      _casesDateGraph.add(
        charts.Series(
            data: _deathList,
            measureFn: (TimeSeries data, _) => data.count,
            domainFn: (TimeSeries data, _) => data.date,
            colorFn: (TimeSeries data, _) => data.colour,
            id: 'Death'),
      );

      return charts.TimeSeriesChart(
        _casesDateGraph,
        animate: true,
        animationDuration: new Duration(seconds: 1),
        behaviors: [new charts.PanAndZoomBehavior(), new charts.SeriesLegend()],
      );
    }

    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(
            height: 70.00,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(flex: 3, child: confirmedTile),
              Expanded(flex: 3, child: recoveredTile),
              Expanded(flex: 3, child: deathTile),
            ],
          ),
          Container(height: 400, child: generateChart()),
          SizedBox(
            height: 70,
          ),
          Text(
            'Time line:',
            style: TextStyle(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          Expanded(
            // height: 400, 
          child: Column(children:[generateDateTimeChart()])
          )
        ],
      ),
    );
  }
}

class Cases {
  charts.Color colour;
  final String type;
  final int number;
  Cases(this.type, this.number, this.colour);
}

class TimeSeries {
  final DateTime date;
  final int count;
  final charts.Color colour;
  TimeSeries(this.date, this.count, this.colour);
}
