import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_forecast_daily.dart';
import '../utilities/constants.dart';
import '../utilities/location.dart';

class WeatherApi {
  Future<WeatherForecast> fetchWeatherForecast(
      {String? city, bool? isCity}) async {
    final parameters = <String, String>{
      'appid': Constants.WEATHER_APP_ID,
      'units': 'metric',
    };

    if (isCity == true) {
      final cityName = city?.trim();
      if (cityName == null || cityName.isEmpty) {
        throw Exception('Введите название города.');
      }
      parameters['q'] = cityName;
    } else {
      final location = Location();
      await location.getCurrentLocation();
      parameters['lat'] = location.latitude.toString();
      parameters['lon'] = location.longitude.toString();
    }

    final uri = Uri.https(
      Constants.WEATHER_BASE_URL_DOMAIN,
      Constants.WEATHER_FORECAST_PATH,
      parameters,
    );

    final response = await http.get(uri).timeout(
          const Duration(seconds: 12),
          onTimeout: () => throw TimeoutException(
            'Сервис погоды не ответил за 12 секунд.',
          ),
        );

    if (response.statusCode != 200) {
      String? apiMessage;
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          apiMessage = decoded['message']?.toString();
        }
      } on FormatException {
        // The server may return a non-JSON error page.
      }

      String message;
      if (response.statusCode == 401) {
        message = 'Сервис погоды отклонил API-ключ. Проверьте его настройки.';
      } else if (response.statusCode == 404) {
        message = 'Город не найден. Проверьте название и попробуйте ещё раз.';
      } else {
        message =
            apiMessage ?? 'Сервис погоды вернул ошибку ${response.statusCode}.';
      }
      throw Exception(message);
    }

    return WeatherForecast.fromFiveDayJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }
}
