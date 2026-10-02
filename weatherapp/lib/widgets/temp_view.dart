import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_forecast_daily.dart';

class TempView extends StatelessWidget {
  final AsyncSnapshot<WeatherForecast> snapshot;

  const TempView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final forecastList = snapshot.data?.list;
    final forecast = forecastList != null && forecastList.isNotEmpty
        ? forecastList.first
        : null;
    final iconUrl = forecast?.getIconUrl() ?? '';
    final temperature = forecast?.temp?.day?.round() ?? 0;
    final description =
        (forecast?.weather?.isNotEmpty == true
                ? forecast!.weather!.first.description
                : null)
            ?.toUpperCase() ??
        '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (iconUrl.isNotEmpty)
          Image.network(
            iconUrl,
            width: 88.0,
            height: 88.0,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.cloud_outlined, size: 64.0),
          )
        else
          const Icon(Icons.cloud_outlined, size: 64.0),
        const SizedBox(width: 20.0),
        Column(
          children: <Widget>[
            Text(
              '$temperature °C',
              style: const TextStyle(fontSize: 50.0, color: Colors.black87),
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
          ],
        ),
      ],
    );
  }
}
