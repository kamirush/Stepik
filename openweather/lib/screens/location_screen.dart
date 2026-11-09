import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api/weather_api.dart';
import 'city_screen.dart';
import 'weather_forecast_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _loadWeather({String? city}) async {
    if (mounted && (!_isLoading || _errorMessage != null)) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final weatherInfo = await WeatherApi().fetchWeatherForecast(
        city: city,
        isCity: city != null,
      );
      if (!mounted) return;

      await Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) =>
              WeatherForecastScreen(locationWeather: weatherInfo),
        ),
      );
    } catch (error, stackTrace) {
      log('Не удалось загрузить погоду: $error', stackTrace: stackTrace);
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(error);
      });
    }
  }

  String _getErrorMessage(Object error) {
    if (error is TimeoutException) {
      return 'Не удалось получить ответ вовремя. Проверьте интернет и попробуйте ещё раз.';
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> _openCitySearch() async {
    final city = await Navigator.push<String>(
      context,
      MaterialPageRoute<String>(builder: (context) => const CityScreen()),
    );

    if (city != null && city.trim().isNotEmpty) {
      await _loadWeather(city: city.trim());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitDoubleBounce(color: Colors.black87, size: 100.0),
                    SizedBox(height: 20),
                    Text('Определяем местоположение и загружаем погоду…'),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage ?? 'Не удалось загрузить погоду.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadWeather,
                        child: const Text('Повторить'),
                      ),
                      TextButton(
                        onPressed: _openCitySearch,
                        child: const Text('Выбрать город'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
