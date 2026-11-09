import 'package:flutter/material.dart';

import '../models/weather_forecast_daily.dart';
import 'weather_icon.dart';

class TempView extends StatelessWidget {
  final AsyncSnapshot<WeatherForecast> snapshot;
  const TempView({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var forecastList = snapshot.data?.list;
    var condition = forecastList?[0].weather[0].main.toLowerCase();
    var temp = forecastList?[0].temp.day.toStringAsFixed(0);
    var description = forecastList?[0].weather[0].description.toUpperCase();
    final weatherIcon = weatherIconFor(condition);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(weatherIcon, size: 108, color: Colors.black87),
        const SizedBox(width: 20.0),
        Column(
          children: <Widget>[
            Text(
              '$temp °C',
              style: const TextStyle(
                fontSize: 54.0,
                color: Colors.black87,
              ),
            ),
            Text(
              '$description',
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
