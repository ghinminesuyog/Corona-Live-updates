// import 'package:corona/main.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartsPage extends StatefulWidget {
  final dynamic datum;
  final String countryName;
  ChartsPage({Key key, @required this.datum, @required this.countryName})
      : super(key: key);
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  List<charts.Series<LineChartData, int>> _lineGraphData;

  Widget drawChart() {
    List<LineChartData> getConfirmedCases() {
      List<LineChartData> confirmedlist = [];
      for (int i = 0; i < widget.datum.length; i++) {
        var date = (widget.datum[i]["date"]);
        // print(date);
        var confirmed = widget.datum[i]["confirmed"];

        var d = new LineChartData(i, confirmed);
        confirmedlist.add(d);
      }
      return confirmedlist;
    }

    List<LineChartData> getRecoveredCases() {
      List<LineChartData> recoveredlist = [];
      for (int i = 0; i < widget.datum.length; i++) {
        var date = (widget.datum[i]["date"]);
        // print(date);
        var recovered = widget.datum[i]["recovered"];

        var d = new LineChartData(i, recovered);
        recoveredlist.add(d);
      }
      return recoveredlist;
    }

    List<LineChartData> getDeathCases() {
      List<LineChartData> deathslist = [];
      for (int i = 0; i < widget.datum.length; i++) {
        var date = (widget.datum[i]["date"]);
        // print(date);
        var deaths = widget.datum[i]["deaths"];

        var d = new LineChartData(i, deaths);
        deathslist.add(d);
      }
      return deathslist;
    }

    var confirmeddata = getConfirmedCases();

    var recovereddata = getRecoveredCases();

    var deathdata = getDeathCases();

    _lineGraphData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.blue),
        id: 'Confirmed',
        data: confirmeddata,
        domainFn: (LineChartData sales, _) => sales.yearval,
        measureFn: (LineChartData sales, _) => sales.salesval,
      ),
    );
    _lineGraphData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.green),
        id: 'Air Pollution',
        data: recovereddata,
        domainFn: (LineChartData sales, _) => sales.yearval,
        measureFn: (LineChartData sales, _) => sales.salesval,
      ),
    );
    _lineGraphData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
        id: 'Air Pollution',
        data: deathdata,
        domainFn: (LineChartData sales, _) => sales.yearval,
        measureFn: (LineChartData sales, _) => sales.salesval,
      ),
    );

    return charts.LineChart(
      _lineGraphData,
      animate: true,
      // barGroupingType: charts.BarGroupingType.grouped,
      //behaviors: [new charts.SeriesLegend()],
      animationDuration: Duration(seconds: 2),
    );
  }

  // var entireJsonResponse;
  // String countryName;
  // var countryData;
  // List<String> countryList;

  // bool incorrectCountryName = false;

  // var showResults = false;
  // var loadingJson = true;

  @override
  void initState() {
    super.initState();
    // fetchJsonResponse();
    // _seriessPieData = List<charts.Series<ChartData, String>>();
    _lineGraphData = List<charts.Series<LineChartData, int>>();
  }

  // fetchJsonResponse() async {
  //   Response response =
  //       await get('https://pomber.github.io/covid19/timeseries.json');
  //   // print(response.body);
  //   var jsonResponse = (response.body);
  //   Map valueMap = json.decode(jsonResponse);
  //   // print(valueMap);
  //   setState(() {
  //     loadingJson = false;
  //   });
  //   var alphabSortedCountries = ((valueMap.keys).toList());
  //   alphabSortedCountries.sort((a, b) => a.toString().compareTo(b.toString()));
  //   countryList = alphabSortedCountries;
  //   entireJsonResponse = valueMap;
  //   return valueMap;
  // }

  // getDataFor(String country) async {
  //   setState(() {
  //     showResults = false;
  //   });

  //   if (widget.datum != null) {
  //     if (country.length > 0) {
  //       countryName = country;

  //       if (widget.datum[countryName] != null) {
  //         countryData = await widget.datum[countryName];
  //         var l = await returnData();
  //         setState(() {
  //           showResults = true;
  //           incorrectCountryName = false;
  //         });
  //         return (l);
  //       } else {
  //         setState(() {
  //           incorrectCountryName = true;
  //         });
  //         print('Wrong country name');
  //       }
  //     } else {
  //       print('Enter a country name');
  //     }
  //   } else {
  //     print('Wait a lil longer');
  //   }
  // }

  // returnData() async {
  //   if (countryData != null) {
  //     Iterable reverseIterable = countryData.reversed;
  //     return reverseIterable.toList();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // var futureBuilder = new FutureBuilder(
    //     // future: returnData(),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.none:
    //           return Text('Press button to start.');

    //         case ConnectionState.active:
    //           return Text('Awaiting result...');
    //         case ConnectionState.waiting:
    //           return Text('Awaiting result...');
    //         case ConnectionState.done:
    //           if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    //           // return Text('Result: ${snapshot.data}');
    //           return drawChart();
    //         default:
    //           return Text('Some error occured');
    //       }
    //     });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 70.00,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: new Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  '${widget.countryName}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // loadingJson == false
            //     ? new DropdownButton<String>(
            //         hint: Text('Select a country'),
            //         value: countryName,
            //         items: countryList.map((String value) {
            //           return new DropdownMenuItem<String>(
            //               value: value, child: new Text(value));
            //         }).toList(),
            //         onChanged: (selectedValue) {
            //           setState(() {
            //             getDataFor(selectedValue);
            //           });
            //         })
            //     : new Column(
            //         children: [
            //           CircularProgressIndicator(),
            //           Text('Loading data ...')
            //         ],
            //       ),
            // showResults == false
            // ? new Container(width: 0.0, height: 0.0)
            // :
            Expanded(child: drawChart())
          ],
        ),
      ),
    );
  }
}

// class ChartData {
//   String date;
//   int confirmed;
//   // int recovered;
//   // int deaths;

//   ChartData(this.date, this.confirmed);
// }

class LineChartData {
  int yearval;
  int salesval;

  LineChartData(this.yearval, this.salesval);
}

class Json {
  var data;
  var countryData;
  Json(this.data, this.countryData);
}
