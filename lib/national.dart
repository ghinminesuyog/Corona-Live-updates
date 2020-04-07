// import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CountryData extends StatefulWidget {
  final Map entireJsonResponse;
  CountryData({Key key, @required this.entireJsonResponse}) : super(key: key);
  @override
  _CountryDataState createState() => _CountryDataState();
}

class _CountryDataState extends State<CountryData> {
  String countryName;
  var countryData;
  List<String> countryList;

  bool displayChart;

  List<charts.Series<DateTimeChart, DateTime>> _dateTimeGraphData;
  List<charts.Series<PieData, String>> _pieChartData;

  @override
  void initState() {
    super.initState();
    countryList = fetchCountryList();
    _dateTimeGraphData = List<charts.Series<DateTimeChart, DateTime>>();
    _pieChartData = List<charts.Series<PieData, String>>();
    displayChart = false;
  }

  List<String> fetchCountryList() {
    var entireJsonResponse = widget.entireJsonResponse;
    var alphabetticallySortedCountries = (entireJsonResponse.keys).toList();
    return alphabetticallySortedCountries;
  }

  getDataFor(String country) {
    setState(() {
      countryName = country;
      countryData = widget.entireJsonResponse[country];
      countryData = returnData();
      // print('Country data is $countryData');
    });
  }

  returnData() {
    if (countryData != null) {
      Iterable reverseIterable = countryData.reversed;
      return reverseIterable.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget drawDateTimeChart() {
      List<DateTimeChart> getConfirmedCases() {
        List<DateTimeChart> confirmedlist = [];
        for (int i = 0; i < countryData.length; i++) {
          var date = (countryData[i]["date"]).toString();

          var dateComponents = date.split("-");
          var day = int.parse(dateComponents[2]);
          var month = int.parse(dateComponents[1]);
          var year = int.parse(dateComponents[0]);

          DateTime constrDate = new DateTime(year, month, day);
          // print(date);

          var confirmed = countryData[i]["confirmed"];

          var d = new DateTimeChart(constrDate, confirmed);
          setState(() {
            confirmedlist.add(d);
          });
        }
        return confirmedlist;
      }

      List<DateTimeChart> getRecoveredCases() {
        List<DateTimeChart> recoveredlist = [];
        for (int i = 0; i < countryData.length; i++) {
          var recovered = countryData[i]["recovered"];

          var date = (countryData[i]["date"]);
          // print(date);
          var dateComponents = date.split("-");
          var day = int.parse(dateComponents[2]);
          var month = int.parse(dateComponents[1]);
          var year = int.parse(dateComponents[0]);

          DateTime constrDate = new DateTime(year, month, day);

          var d = new DateTimeChart(constrDate, recovered);
          setState(() {
            recoveredlist.add(d);
          });
        }
        return recoveredlist;
      }

      List<DateTimeChart> getDeathCases() {
        List<DateTimeChart> deathslist = [];
        for (int i = 0; i < countryData.length; i++) {
          // print(date);
          var deaths = countryData[i]["deaths"];
          var date = (countryData[i]["date"]);
          // print(date);
          var dateComponents = date.split("-");
          var day = int.parse(dateComponents[2]);
          var month = int.parse(dateComponents[1]);
          var year = int.parse(dateComponents[0]);
          DateTime constrDate = new DateTime(year, month, day);

          var d = new DateTimeChart(constrDate, deaths);

          setState(() {
            deathslist.add(d);
          });
        }

        return deathslist;
      }

      List<DateTimeChart> confirmeddata, recovereddata, deathdata;

      confirmeddata = getConfirmedCases();

      recovereddata = getRecoveredCases();

      deathdata = getDeathCases();

      _dateTimeGraphData.add(
        charts.Series(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.blue),
          id: 'Confirmed',
          data: confirmeddata,
          domainFn: (DateTimeChart sales, _) => sales.date,
          measureFn: (DateTimeChart sales, _) => sales.count,
        ),
      );
      _dateTimeGraphData.add(
        charts.Series(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.green),
          id: 'Recovered',
          data: recovereddata,
          domainFn: (DateTimeChart sales, _) => sales.date,
          measureFn: (DateTimeChart sales, _) => sales.count,
        ),
      );
      _dateTimeGraphData.add(
        charts.Series(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
          id: 'Deaths',
          data: deathdata,
          domainFn: (DateTimeChart sales, _) => sales.date,
          measureFn: (DateTimeChart sales, _) => sales.count,
        ),
      );
      return new charts.TimeSeriesChart(
        _dateTimeGraphData,
        animate: true,
        animationDuration: new Duration(seconds: 2),
        behaviors: [
          new charts.SeriesLegend(),
          // new charts.DatumLegend(),
          new charts.SlidingViewport(),
          // A pan and zoom behavior helps demonstrate the sliding viewport
          // behavior by allowing the data visible in the viewport to be adjusted
          // dynamically.
          new charts.PanAndZoomBehavior(),
        ],
      );
    }

    Widget drawPieChart() {
      // _pieChartData.clear();

      getConfirmedToday() {
        var latestData = countryData[0];
        return latestData['confirmed'];
      }

      getRecoveredToday() {
        var latestData = countryData[0];
        return latestData['recovered'];
      }

      getDeathsToday() {
        var latestData = countryData[0];
        return latestData['deaths'];
      }

      int confirmed =
          getConfirmedToday() - getRecoveredToday() - getDeathsToday();
      int recovered = getRecoveredToday();
      int deaths = getDeathsToday();

      var pieData = [
        PieData('Confirmed', confirmed,
            charts.ColorUtil.fromDartColor(Colors.blue)),
        PieData('Recovered', recovered,
            charts.ColorUtil.fromDartColor(Colors.green)),
        PieData('Deaths', deaths, charts.ColorUtil.fromDartColor(Colors.red)),
      ];

      _pieChartData.add(
        charts.Series(
            id: 'Pie chart',
            data: pieData,
            measureFn: (PieData data, _) => data.cases,
            domainFn: (PieData data, _) => data.type,
            colorFn: (PieData data, _) => data.colour),
      );

      return charts.PieChart(
        _pieChartData,
        animate: true,
        animationDuration: Duration(seconds: 1),
      );
    }

    Widget pieRow() {
      getConfirmedToday() {
        var latestData = countryData[0];
        return latestData['confirmed'];
      }

      getRecoveredToday() {
        var latestData = countryData[0];
        return latestData['recovered'];
      }

      getDeathsToday() {
        var latestData = countryData[0];
        return latestData['deaths'];
      }

      int confirmed = getConfirmedToday();
      int recovered = getRecoveredToday();
      int deaths = getDeathsToday();

      Widget confirmedTile = Container(
        decoration: new BoxDecoration(
          color: Colors.blue,
          borderRadius: new BorderRadius.circular(10.00),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              '$confirmed',
              style: TextStyle(fontSize: 20.00, color: Colors.white),
            ),
            Text(
              'Confirmed',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );

      Widget recoveredTile = Container(
        decoration: new BoxDecoration(
          color: Colors.green,
          borderRadius: new BorderRadius.circular(10.00),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
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
      );

      Widget deathTile = Container(
        decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: new BorderRadius.circular(10.00),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              '$deaths',
              style: TextStyle(fontSize: 20.00, color: Colors.white),
            ),
            Text(
              'Deaths',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: confirmedTile,
          ),
          Expanded(
            flex: 3,
            child: recoveredTile,
          ),
          Expanded(
            flex: 3,
            child: deathTile,
          ),
        ],
      );
    }

    ;
    Widget dropdownMenu = new DropdownButton<String>(
      isExpanded: true,
      hint: Text('Select a country'),
      value: countryName,
      items: countryList.map((String value) {
        return new DropdownMenuItem<String>(
            value: value, child: new Text(value));
      }).toList(),
      onChanged: (selectedValue) {
        setState(() {
          displayChart = true;
        });
        getDataFor(selectedValue);
        _dateTimeGraphData = [];
        _pieChartData = [];
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 70.00,
                ),
                //     ?
                new Padding(padding: EdgeInsets.all(10), child: dropdownMenu),
                (displayChart)
                    ? Text(
                        'Today:',
                        style: TextStyle(fontSize: 26),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                (displayChart)
                    ? Container(
                        // height: 200,
                        child: pieRow(),
                      )
                    : Container(),
                // SizedBox(
                //   height: 100,
                // ),
                (displayChart)
                    ? Container(
                        height: 400,
                        child: drawPieChart(),
                      )
                    : Container(),
                SizedBox(
                  height: 50,
                ),
                (displayChart)
                    ? Text(
                        'Time line:',
                        style: TextStyle(fontSize: 26),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                (displayChart)
                    ? Container(
                        height: 400,
                        child: drawDateTimeChart(),
                      )
                    : Container(),
                SizedBox(
                  height: 70.00,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimeChart {
  DateTime date;
  int count;
  DateTimeChart(this.date, this.count);
}

class PieData {
  charts.Color colour;
  String type;
  int cases;
  PieData(this.type, this.cases, this.colour);
}
