import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weatherapp/models/weather_forecast_daily.dart';
import 'package:weatherapp/utilities/forecast_util.dart';

class DetailView extends StatelessWidget {
  final AsyncSnapshot<WeatherForecast> snapshot;

  const DetailView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final forecastList = snapshot.data?.list;
    final forecast = forecastList != null && forecastList.isNotEmpty
        ? forecastList.first
        : null;
    final pressure = ((forecast?.pressure ?? 0) * 0.750062).round();
    final humidity = forecast?.humidity ?? 0;
    final wind = forecast?.speed?.round() ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Util.getItem(
          FontAwesomeIcons.temperatureThreeQuarters,
          pressure,
          'mm Hg',
        ),
        Util.getItem(FontAwesomeIcons.cloudRain, humidity, '%'),
        Util.getItem(FontAwesomeIcons.wind, wind, 'm/s'),
      ],
    );
  }
}
