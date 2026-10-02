import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_forecast_daily.dart';
import 'package:weatherapp/utilities/forecast_util.dart';

class CityView extends StatelessWidget {
  final AsyncSnapshot<WeatherForecast> snapshot;

  const CityView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final forecastList = snapshot.data?.list;
    final firstForecast = forecastList != null && forecastList.isNotEmpty
        ? forecastList.first
        : null;
    final city = snapshot.data?.city?.name ?? '';
    final country = snapshot.data?.city?.country ?? '';
    final timestamp = firstForecast?.dt ?? 0;
    final formattedDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    return Column(
      children: <Widget>[
        Text(
          country.isEmpty ? city : '$city, $country',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
            color: Colors.black87,
          ),
        ),
        Text(
          Util.getFormattedDate(formattedDate),
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
      ],
    );
  }
}
