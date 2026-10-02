import 'package:flutter/material.dart';
import 'package:weatherapp/utilities/location.dart';
import 'screens/weather_forecast_screen.dart';
import 'screens/location_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationScreen(),
    );
  }
}
