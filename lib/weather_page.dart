import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/route_generator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class weather extends StatefulWidget {
  const weather({Key? key}) : super(key: key);

  @override
  _weatherState createState() => _weatherState();
}

class _weatherState extends State<weather> {
  @override
  void initState() {
    weather_api();
    super.initState();
  }

  @override
  static const weatherApiUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  String apiKey = 'd22bb2d4a189ec1fdf6d4629dfbe60e7';

  int temperature = 0;
  String condition = '';
  int humidity = 0;
  String country = '';
  String city = '';
  int feels = 0;

  weather_api() async {
    late double latitude;
    late double longitude;
    int status;
    LocationPermission permission;
    try {
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print('Error $e');
    }
    print(latitude);
    print(longitude);

    http.Response response = await http.get(Uri.parse(
        '$weatherApiUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));
    print(
        '$weatherApiUrl?lat= $latitude &lon=$longitude &appid=$apiKey&units=metric');
    if (response.statusCode == 200) {
      String data = response.body;
      double temp = jsonDecode(data)['main']['temp'];
      double feels_temp = jsonDecode(data)['main']['feels_like'];
      print(jsonDecode(data));
      setState(() {
        condition = jsonDecode(data)['weather'][0]['main'];
        humidity = jsonDecode(data)['main']['humidity'];
        country = jsonDecode(data)['sys']['country'];
        city = jsonDecode(data)['name'];
        temperature = temp.toInt();
        feels = feels_temp.toInt();
      });
    } else {
      print("Error status ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://i.pinimg.com/736x/c3/40/37/c34037e4537544991bca11017f0d20e9.jpg"),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),
            ),
          ),
          Positioned(
              child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Spacer(),
                      const Icon(
                        Icons.edit_location,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        '$country',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 24,
                          width: 100,
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$temperature",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 64,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        "🌡C",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "Feels like $feels",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const VerticalDivider(
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.cloud,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                  Text(
                                    "$condition",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Text(
                          city,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
