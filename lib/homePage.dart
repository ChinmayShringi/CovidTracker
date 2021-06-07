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
  static List<dynamic> allCountries;

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
    allCountries = json['Countries'];

    return Covid(
      newConfirmed: json['Global']['NewConfirmed'],
      totalConfirmed: json['Global']['TotalConfirmed'],
      newDeaths: json['Global']['NewDeaths'],
      totalDeaths: json['Global']['TotalDeaths'],
      newRecovered: json['Global']['NewRecovered'],
      totalRecovered: json['Global']['TotalRecovered'],
    );
  }
  factory Covid.fromJsonCountry(String country) {
    List temp = allCountries.where((i) => i['Country'] == country).toList();
    return Covid(
      country: temp[0]['Country'],
      countryCode: temp[0]['CountryCode'],
      slug: temp[0]['Slug'],
      newConfirmed: temp[0]['NewConfirmed'],
      totalConfirmed: temp[0]['TotalConfirmed'],
      newDeaths: temp[0]['NewDeaths'],
      totalDeaths: temp[0]['TotalDeaths'],
      newRecovered: temp[0]['NewRecovered'],
      totalRecovered: temp[0]['TotalRecovered'],
      date: temp[0]['Date'],
    );
  }
}

Covid fetchCovidCountry({String country = 'India'}) {
  try {
    return Covid.fromJsonCountry(country);
  } catch (e) {
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
  Covid futureCovidCountry;
  String dropValue = "Default Country";
  bool isSet = false;

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
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeWidth = MediaQuery.of(context).size.width;

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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Global Count\n",
                          style: kTitleTextstyle,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // Text(
                  //   "See details",
                  //   style: TextStyle(
                  //     color: kPrimaryColor,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ],
              ),
            ),
            FutureBuilder<Covid>(
              future: futureCovidGlobal,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return
                      // number: snapshot.data.newConfirmed,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CovidFigure(
                              color: kInfectedColor,
                              number: snapshot.data.totalRecovered,
                              title: "Recovered",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CovidFigure(
                                color: kDeathColor,
                                number: snapshot.data.totalDeaths,
                                title: "Deaths",
                              ),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CovidFigure(
                                color: kRecovercolor,
                                number: snapshot.data.totalConfirmed,
                                title: "Total",
                              ),
                            ]),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
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
                              text: "Country Wise\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Latest update!",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      // Text(
                      //   "See details",
                      //   style: TextStyle(
                      //     color: kPrimaryColor,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: sizeWidth * 0.02),
                    padding: EdgeInsets.symmetric(
                        vertical: sizeHeight * 0.01,
                        horizontal: sizeWidth * 0.02),
                    height: sizeHeight * 0.06,
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
                        SizedBox(width: 20),
                        FutureBuilder<Covid>(
                          future: futureCovidGlobal,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List dropDown = Covid.allCountries
                                  .map((data) => data['Country'])
                                  .toList();
                              dropDown.add("Default Country");
                              return Expanded(
                                child: DropdownButton(
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  icon: Icon(Icons.arrow_drop_down),
                                  value: dropValue,
                                  items: [...dropDown]
                                      .map<DropdownMenuItem<String>>(
                                          (dynamic value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      this.dropValue = value;
                                      futureCovidCountry =
                                          fetchCovidCountry(country: value);
                                      this.isSet = futureCovidCountry == null
                                          ? false
                                          : true;
                                    });
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
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
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CovidFigure(
                              color: kRecovercolor,
                              number: this.isSet
                                  ? this.futureCovidCountry.totalRecovered
                                  : 46,
                              title: " Total Recovered",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CovidFigure(
                              color: kDeathColor,
                              number: this.isSet
                                  ? this.futureCovidCountry.totalDeaths
                                  : 87,
                              title: "Total Deaths",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CovidFigure(
                              color: kInfectedColor,
                              number: this.isSet
                                  ? this.futureCovidCountry.totalConfirmed
                                  : 1046,
                              title: "Total Cases",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CovidFigure(
                              color: kDeathColor,
                              number: this.isSet
                                  ? this.futureCovidCountry.newConfirmed
                                  : 1046,
                              title: "New Cases",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CovidFigure(
                              color: kDeathColor,
                              number: this.isSet
                                  ? this.futureCovidCountry.newDeaths
                                  : 1046,
                              title: "New Deaths",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CovidFigure(
                              color: kRecovercolor,
                              number: this.isSet
                                  ? this.futureCovidCountry.newRecovered
                                  : 1046,
                              title: "New Recovered",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
