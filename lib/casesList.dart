// import 'package:corona/main.dart';
// import 'package:corona/chartPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class CasesList extends StatefulWidget {
  @override
  _CasesListState createState() => _CasesListState();
}

class _CasesListState extends State<CasesList> {
  var entireJsonResponse;
  String countryName;
  var countryData;
  List<String> countryList;
  List<charts.Series<LineChartData, int>> _lineGraphData;

  var showResults = false;
  var loadingJson = true;
  var showChart = false;

  Widget _listViewBuilder(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> values = snapshot.data;

    return ListView.builder(
        shrinkWrap: true,
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: (index % 2 == 0) ? Color(0xFFd6d6d6) : Colors.white,
            child: ListTile(
                leading: Text((values[index]["date"]).toString()),
                title: Container(
                  child: Row(
                    children: [
                      Text(
                        (values[index]["confirmed"]).toString(),
                        style: TextStyle(color: Colors.blue, fontSize: 25.00),
                      ),
                      SizedBox(
                        width: 1.0,
                      ),
                      Text('confirmed'),
                    ],
                  ),
                ),
                subtitle: Container(
                  child: Column(
                    children: <Widget>[
                      Row(children: [
                        Text(
                          (values[index]["recovered"]).toString(),
                          style:
                              TextStyle(color: Colors.green, fontSize: 25.00),
                        ),
                        SizedBox(
                          width: 1.0,
                        ),
                        Text('recovered'),
                      ]),
                      Row(children: [
                        Text(
                          (values[index]["deaths"]).toString(),
                          style: TextStyle(color: Colors.red, fontSize: 25.00),
                        ),
                        SizedBox(
                          width: 1.0,
                        ),
                        Text('deaths'),
                      ])
                    ],
                  ),
                )),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    fetchJsonResponse();
    _lineGraphData = List<charts.Series<LineChartData, int>>();
  }

  fetchJsonResponse() async {
    Response response =
        await get('https://pomber.github.io/covid19/timeseries.json');
    var jsonResponse = (response.body);
    Map valueMap = json.decode(jsonResponse);
    setState(() {
      loadingJson = false;
    });
    var alphabSortedCountries = ((valueMap.keys).toList());
    alphabSortedCountries.sort((a, b) => a.toString().compareTo(b.toString()));
    countryList = alphabSortedCountries;
    entireJsonResponse = valueMap;
    // jsonData = valueMap;
    return valueMap;
  }

  getDataFor(String country) async {
    setState(() {
      showResults = false;
    });

    if (entireJsonResponse != null) {
      if (country.length > 0) {
        // var noSpacesCountryName = country.replaceAll(' ', '');
        // print(noSpacesCountryName);
        countryName = country;

        // print(entireJsonResponse[countryName]);
        if (entireJsonResponse[countryName] != null) {
         
          countryData = entireJsonResponse[countryName];
          var l = await returnData();
          setState(() {
            showResults = true;
            // incorrectCountryName = false;
            // generateData();
          });
          return (l);
        } else {
          print('Wrong country name');
        }
      } else {
        print('Enter a country name');
      }
    } else {
      print('Wait a lil longer');
    }
  }

  returnData() async {
    if (countryData != null) {
      Iterable reverseIterable = countryData.reversed;
      return reverseIterable.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    var futureBuilder = new FutureBuilder(
        future: returnData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');

            case ConnectionState.active:
              return Text('Awaiting result...');
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              // return Text('Result: ${snapshot.data}');
              return _listViewBuilder(context, snapshot);
            default:
              return Text('Some error occured');
          }
        });

    Widget drawChart() {
      List<LineChartData> getConfirmedCases() {
        List<LineChartData> confirmedlist = [];
        for (int i = 0; i < countryData.length; i++) {
          var date = (countryData[i]["date"]);
          // print(date);
          var confirmed = countryData[i]["confirmed"];

          var d = new LineChartData(i, confirmed);
          confirmedlist.add(d);
        }
        return confirmedlist;
      }

      List<LineChartData> getRecoveredCases() {
        List<LineChartData> recoveredlist = [];
        for (int i = 0; i < countryData.length; i++) {
          var date = (countryData[i]["date"]);
          // print(date);
          var recovered = countryData[i]["recovered"];

          var d = new LineChartData(i, recovered);
          recoveredlist.add(d);
        }
        return recoveredlist;
      }

      List<LineChartData> getDeathCases() {
        List<LineChartData> deathslist = [];
        for (int i = 0; i < countryData.length; i++) {
          var date = (countryData[i]["date"]);
          // print(date);
          var deaths = countryData[i]["deaths"];

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
          measureFn: (LineChartData sales, _) => sales.count,
        ),
      );
      _lineGraphData.add(
        charts.Series(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.green),
          id: 'Recovered',
          data: recovereddata,
          domainFn: (LineChartData sales, _) => sales.yearval,
          measureFn: (LineChartData sales, _) => sales.count,
        ),
      );
      _lineGraphData.add(
        charts.Series(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
          id: 'Deaths',
          data: deathdata,
          domainFn: (LineChartData sales, _) => sales.yearval,
          measureFn: (LineChartData sales, _) => sales.count,
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 70.00,
          ),
          loadingJson == false
              ? Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new DropdownButton<String>(
                        hint: Text('Select a country'),
                        value: countryName,
                        items: countryList.map((String value) {
                          return new DropdownMenuItem<String>(
                              value: value, child: new Text(value));
                        }).toList(),
                        onChanged: (selectedValue) {
                          setState(() {
                            getDataFor(selectedValue);
                          });
                        }),
                    (countryName == null)
                        ? Container()
                        : IconButton(
                            icon: new Icon(Icons.insert_chart),
                            onPressed: () {
                              setState(() {
                                showChart = !showChart;
                              });
                            },
                          )
                  ],
                )
              : new Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Loading data ...')
                  ],
                ),
          showResults == false
              ? new Container(width: 0.0, height: 0.0)
              : (Expanded(child: showChart ? drawChart() : futureBuilder))
        ],
      ),
    );
  }
}

class LineChartData {
  int yearval;
  int count;
  LineChartData(this.yearval, this.count);
}
