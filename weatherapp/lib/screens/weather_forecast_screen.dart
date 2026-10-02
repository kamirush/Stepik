import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/api/weather_api.dart';
import 'package:weatherapp/models/weather_forecast_daily.dart';
import 'package:weatherapp/screens/city_screen.dart';
import 'package:weatherapp/screens/location_screen.dart';
import 'package:weatherapp/widgets/bottom_list_view.dart';
import 'package:weatherapp/widgets/city_view.dart';
import 'package:weatherapp/widgets/detail_view.dart';
import 'package:weatherapp/widgets/temp_view.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  String _cityName = 'London';
  Position? _position;
  late Future<WeatherForecast> _forecast;

  @override
  void initState() {
    super.initState();
    _forecast = _weatherApi.fetchWeatherForecastWithCity(cityName: _cityName);
  }

  Future<void> _openCityScreen() async {
    final cityName = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (context) => CityScreen(initialCity: _cityName),
      ),
    );

    if (!mounted || cityName == null) return;

    setState(() {
      _cityName = cityName;
      _position = null;
      _forecast = _weatherApi.fetchWeatherForecastWithCity(cityName: cityName);
    });
  }

  Future<void> _openLocationScreen() async {
    final position = await Navigator.of(context).push<Position>(
      MaterialPageRoute<Position>(builder: (context) => const LocationScreen()),
    );

    if (!mounted || position == null) return;

    setState(() {
      _position = position;
      _forecast = _weatherApi.fetchWeatherForecastWithCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });
  }

  void _retry() {
    setState(() {
      final position = _position;
      _forecast = position == null
          ? _weatherApi.fetchWeatherForecastWithCity(cityName: _cityName)
          : _weatherApi.fetchWeatherForecastWithCoordinates(
              latitude: position.latitude,
              longitude: position.longitude,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather forecast'),
        leading: IconButton(
          tooltip: 'Use current location',
          icon: const Icon(Icons.my_location),
          onPressed: _openLocationScreen,
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Choose city',
            icon: const Icon(Icons.location_city),
            onPressed: _openCityScreen,
          ),
        ],
      ),
      body: FutureBuilder<WeatherForecast>(
        future: _forecast,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ForecastError(
              message: snapshot.error.toString(),
              onRetry: _retry,
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: SpinKitDoubleBounce(color: Colors.black87, size: 76.0),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 44.0),
                CityView(snapshot: snapshot),
                const SizedBox(height: 62.0),
                TempView(snapshot: snapshot),
                const SizedBox(height: 52.0),
                DetailView(snapshot: snapshot),
                const SizedBox(height: 48.0),
                BottomListView(snapshot: snapshot),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ForecastError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ForecastError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_outlined, size: 48.0),
            const SizedBox(height: 16.0),
            const Text(
              'Could not load the forecast',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16.0),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
