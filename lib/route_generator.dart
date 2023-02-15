import 'package:flutter/material.dart';
import 'package:weather_app_flutter/main.dart';
import 'package:weather_app_flutter/register.dart';
import 'package:weather_app_flutter/weather_page.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/register':
        return MaterialPageRoute(builder: (_) => register());
      case '/weather_page':
        return MaterialPageRoute(builder: (_) => weather());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error")
        ),
        body: const Center(
          child: Text("Error"),
        ),
      );
    });
  }
}