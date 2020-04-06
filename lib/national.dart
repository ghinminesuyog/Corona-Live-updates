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

  @override
  void initState() {
    super.initState();
    countryList = fetchCountryList();
    _dateTimeGraphData = List<charts.Series<DateTimeChart, DateTime>>();
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
      print('Country data is $countryData');
    });
  }

  returnData()  {
    if (countryData != null) {
      Iterable reverseIterable = countryData.reversed;
      return reverseIterable.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget drawChart() {
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

    Widget dropdownMenu = new DropdownButton<String>(
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
      },
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 70.00,
              ),
              //     ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [dropdownMenu],
              ),
              (displayChart) ? Expanded(child: drawChart()) : Container(),
              SizedBox(
                height: 70.00,
              ),
            ],
          ),
        )));
  }
}

class DateTimeChart {
  DateTime date;
  int count;
  DateTimeChart(this.date, this.count);
}
