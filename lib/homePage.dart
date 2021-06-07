import 'package:covidtrack/aboutPage.dart';
import 'package:covidtrack/main.dart';
import 'package:covidtrack/pseudoAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Covid {
  String country;
  String countryCode;
  String slug;
  int newConfirmed;
  int totalConfirmed;
  int newDeaths;
  int totalDeaths;
  int newRecovered;
  int totalRecovered;
  String date;

  Covid({
    this.country,
    this.countryCode,
    this.slug,
    this.newConfirmed,
    this.totalConfirmed,
    this.newDeaths,
    this.totalDeaths,
    this.newRecovered,
    this.totalRecovered,
    this.date,
  });

  factory Covid.fromJsonGlobal(Map<String, dynamic> json) {
    return Covid(
      newConfirmed: json['Global']['NewConfirmed'],
      totalConfirmed: json['Global']['TotalConfirmed'],
      newDeaths: json['Global']['NewDeaths'],
      totalDeaths: json['Global']['TotalDeaths'],
      newRecovered: json['Global']['NewRecovered'],
      totalRecovered: json['Global']['TotalRecovered'],
    );
  }
  factory Covid.fromJsonCountry(Map<String, dynamic> json) {
    print(json['Countries'][0]);
    // return Covid(
    //   country: json['Country'],
    //   countryCode: json['CountryCode'],
    //   slug: json['Slug'],
    //   newConfirmed: json['NewConfirmed'],
    //   totalConfirmed: json['TotalConfirmed'],
    //   newDeaths: json['NewDeaths'],
    //   totalDeaths: json['TotalDeaths'],
    //   newRecovered: json['NewRecovered'],
    //   totalRecovered: json['TotalRecovered'],
    //   date: json['Date'],
    // );
  }
}

Future<Covid> fetchCovidCountry() async {
  final response =
      await http.get(Uri.parse('https://api.covid19api.com/summary'));
  print(response);
  if (response.statusCode == 200) {
    // print(jsonDecode(response.body.['Countries']));
    return Covid.fromJsonCountry(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Covid');
  }
}

Future<Covid> fetchCovidGlobal() async {
  final response =
      await http.get(Uri.parse('https://api.covid19api.com/summary'));
  if (response.statusCode == 200) {
    return Covid.fromJsonGlobal(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Covid');
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();
  double offset = 0;
  Future<Covid> futureCovidGlobal;
  Future<Covid> futureCovidCountry;

  @override
  void initState() {
    super.initState();
    futureCovidGlobal = fetchCovidGlobal();
    // futureCovidCountry = fetchCovidCountry();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _deviceHeight = MediaQuery.of(context).size.height;
    var _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            PseudoAppBar(
              textTop: "All you need",
              textBottom: "is stay at home.",
              offset: offset,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02),
              padding: EdgeInsets.symmetric(
                  vertical: _deviceHeight * 0.01,
                  horizontal: _deviceWidth * 0.02),
              height: _deviceHeight * 0.06,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  // SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down),
                      value: "Indonesia",
                      items: [
                        'Indonesia',
                        'Bangladesh',
                        'United States',
                        'Japan'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Covid Prevention",
                        style: kTitleTextstyle,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AboutPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "See details",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case Update\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Newest update March 28",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        "See details",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<Covid>(
                    future: futureCovidGlobal,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot);
                        return Text('${snapshot.data.newConfirmed}');
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // CovidFigure(
                        //   color: kInfectedColor,
                        //   number: 1046,
                        //   title: "Infected",
                        // ),
                        // CovidFigure(
                        //   color: kDeathColor,
                        //   number: 87,
                        //   title: "Deaths",
                        // ),
                        // CovidFigure(
                        //   color: kRecovercolor,
                        //   number: 46,
                        //   title: "Recovered",
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
