import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weatherapp/api/weather_api.dart';
import 'package:weatherapp/screens/weather_forecast_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    try {
      var weatherInfo = await WeatherApi().fetchWeatherForecast();

      if (!mounted) return;

      if (weatherInfo == null) {
        print('WeatherInfo was null: $weatherInfo');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WeatherForecastScreen(locationWeather: weatherInfo);
          },
        ),
      );
    } catch (e) {
      print('Error fetching location weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}