import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather_forecast_daily.dart';
import 'package:weatherapp/utilities/constants.dart';
import 'package:weatherapp/utilities/location.dart';

class WeatherApi {
  Future<WeatherForecast> fetchWeatherForecast({
    String? cityName,
    bool isCity = false,
  }) async {
    Map<String, String> parameters;

    if (isCity == true && cityName != null) {
      parameters = {
        'APPID': Constants.WEATHER_APP_ID,
        'units': 'metric',
        'q': cityName,
      };
    } else {
      Location location = Location();
      await location.getCurrentLocation();

      parameters = {
        'APPID': Constants.WEATHER_APP_ID,
        'units': 'metric',
        'lat': location.latitude?.toString() ?? '0',
        'lon': location.longitude?.toString() ?? '0',
      };
    }

    var uri = Uri.https(
      Constants.WEATHER_BASE_URL_DOMAIN,
      Constants.WEATHER_FORECAST_PATH,
      parameters,
    );

    log('request: ${uri.toString()}');

    var response = await http.get(uri);

    log('response: ${response.body}');

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error response');
    }
  }
}