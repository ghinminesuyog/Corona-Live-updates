import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController myController = TextEditingController();

  var entireJsonResponse;
  String countryName;
  var countryData;
  List<String> countryList;

  bool incorrectCountryName = false;

  var showResults = false;
  var loadingJson = true;

  Widget _listViewBuilder(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> values = snapshot.data;

    return ListView.builder(
        // physics: const AlwaysScrollableScrollPhysics(),

        // scrollDirection: Axis.vertical,
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
  }

  fetchJsonResponse() async {
    // super.initState();
    // setState(() {
    //   loadingJson = false;
    // });

    Response response =
        await get('https://pomber.github.io/covid19/timeseries.json');
    // print(response.body);
    var jsonResponse = (response.body);
    Map valueMap = json.decode(jsonResponse);
    // print(valueMap);
    setState(() {
      loadingJson = false;
    });
    countryList = (valueMap.keys).toList();
    entireJsonResponse = valueMap;
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
          countryData = await entireJsonResponse[countryName];
          var l = await returnData();
          setState(() {
            showResults = true;
            incorrectCountryName = false;
          });
          return (l);
        } else {
          setState(() {
            incorrectCountryName = true;
          });
          // print('Wrong country name');
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
              loadingJson == false
                  ? new DropdownButton<String>(
                    hint: Text(
                      'Select a country'
                    ),
                    value: countryName,
                      items: countryList.map((String value) {
                        return new DropdownMenuItem<String>(
                            value: value, child: new Text(value));
                      }).toList(),
                      onChanged: (selectedValue) {
                        setState(() {
                          getDataFor(selectedValue);
                        });
                      })
                  : new CircularProgressIndicator(),

              // loadingJson == false
              //     ? new Container(width: 0.0, height: 0.0)
              //     : new CircularProgressIndicator(),

              incorrectCountryName == false
                  ? new Container(width: 0.0, height: 0.0)
                  : new Text(
                      'Incorrect Country name',
                      style: TextStyle(color: Colors.red),
                    ),

              showResults == false
                  ? new Container(width: 0.0, height: 0.0)
                  : Expanded(child: futureBuilder)
            ],
          ),
        ),
      ),
    );
  }
}