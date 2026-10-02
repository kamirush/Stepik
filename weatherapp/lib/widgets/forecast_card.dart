import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_forecast_daily.dart';
import 'package:weatherapp/utilities/forecast_util.dart';

Widget forecastCard(AsyncSnapshot<WeatherForecast> snapshot, int index) {
  var forecastList = snapshot.data?.list;
  var dayOfWeek = '';
  var tempMin = '';
  var icon = '';

  var item = forecastList?[index];

  if (item != null) {
    if (item.dt != null) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(item.dt! * 1000);
      var fullDate = Util.getFormattedDate(date);
      dayOfWeek = fullDate.split(',')[0];
    }

    if (item.temp?.min != null) {
      tempMin = item.temp!.min!.toStringAsFixed(0);
    }

    icon = item.getIconUrl();
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dayOfWeek,
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$tempMin °C',
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (icon.isNotEmpty)
                    Image.network(
                      icon,
                      scale: 1.2,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}