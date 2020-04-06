import 'package:corona/myapp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'classes.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(FetchingData());

class FetchingData extends StatefulWidget {
  @override
  _FetchingDataState createState() => _FetchingDataState();
}

class _FetchingDataState extends State<FetchingData> {
  Widget loadingStatus;
  AvailableData data;
  Map national;
  Global global; 

  @override
  void initState() {
    super.initState();

    loadingStatus =
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(),
      SizedBox(
        height: 10,
      ),
      Text('Loading...')
    ]);

    fetchCountryWiseJson().then(
        (res){
          fetchGlobalData();
          }
         
    );
    
  }

  Future fetchCountryWiseJson() async {
    http.Response response =
        await http.get('https://pomber.github.io/covid19/timeseries.json');
    var jsonResponseAsString = response.body;
    Map jsonObject = json.decode(jsonResponseAsString);

    setState(() {
      national = jsonObject;
    });


  }

  fetchGlobalData() async {
    DateTime today = new DateTime.now();
    int year = today.year;
    int month = today.month;
    int dayToday = today.day;

    DateTime yesterday = new DateTime(year, month,dayToday,-24);
    // print('Yesterday: $yesterday');
    int day = yesterday.day;
    // Check for yesterday's data instead of today's; today might not be updated:
    String constructedDate = '$year-$month-$day';
    // print(constructedDate);

    String url = 'https://covidapi.info/api/v1/global/$constructedDate';
    http.Response response = await http.get(url);
    var jsonResponseString = response.body;
    Map jsonObject = json.decode(jsonResponseString);
    print(jsonObject);

    Map result = jsonObject['result'];

    int confirmed = result["confirmed"];
    int deaths = result['deaths'];
    int recovered = result['recovered'];

    Global global = Global(confirmed,recovered,deaths);

    setState(() {
      global = global;

      data = AvailableData(national, global);

      loadingStatus = MyApp(jsonData: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: loadingStatus,
        ),
      ),
    );
  }
}
