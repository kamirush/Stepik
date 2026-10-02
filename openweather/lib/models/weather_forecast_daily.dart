import '../utilities/constants.dart';

class WeatherForecast {
  late City city;
  late String cod;
  late double message;
  late int cnt;
  List<WeatherList>? list;

  WeatherForecast({
    required this.city,
    required this.cod,
    required this.message,
    required this.cnt,
    this.list,
  });

  WeatherForecast.fromJson(Map<String, dynamic> json) {
    city = (json['city'] != null ? City.fromJson(json['city']) : null) as City;
    cod = json['cod'].toString();
    message = (json['message'] as num).toDouble();
    cnt = (json['cnt'] as num).toInt();
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(WeatherList.fromJson(v));
      });
    }
  }

  factory WeatherForecast.fromFiveDayJson(Map<String, dynamic> json) {
    final city = City.fromJson(json['city'] as Map<String, dynamic>);
    final forecastSamples = json['list'] as List<dynamic>? ?? const [];
    final samplesByDate = <String, List<Map<String, dynamic>>>{};

    DateTime localTime(Map<String, dynamic> sample) {
      final timestamp = (sample['dt'] as num).toInt();
      return DateTime.fromMillisecondsSinceEpoch(
        timestamp * 1000,
        isUtc: true,
      ).add(Duration(seconds: city.timezone));
    }

    for (final rawSample in forecastSamples) {
      final sample = rawSample as Map<String, dynamic>;
      final date = localTime(sample);
      final dateKey = '${date.year}-${date.month}-${date.day}';
      samplesByDate.putIfAbsent(dateKey, () => []).add(sample);
    }

    Map<String, dynamic> nearestSample(
      List<Map<String, dynamic>> samples,
      int targetHour,
    ) {
      var nearest = samples.first;
      var nearestDistance = 24;
      for (final sample in samples) {
        final distance = (localTime(sample).hour - targetHour).abs();
        if (distance < nearestDistance) {
          nearest = sample;
          nearestDistance = distance;
        }
      }
      return nearest;
    }

    double temperature(Map<String, dynamic> sample, String key) {
      final main = sample['main'] as Map<String, dynamic>;
      final value = main[key] ?? main['temp'];
      return (value as num).toDouble();
    }

    final dailyForecasts = samplesByDate.values.take(5).map((samples) {
      samples.sort(
        (first, second) => (first['dt'] as num).compareTo(second['dt'] as num),
      );
      final daySample = nearestSample(samples, 12);
      final morningSample = nearestSample(samples, 9);
      final eveningSample = nearestSample(samples, 18);
      final nightSample = nearestSample(samples, 0);
      final dayMain = daySample['main'] as Map<String, dynamic>;
      final morningMain = morningSample['main'] as Map<String, dynamic>;
      final eveningMain = eveningSample['main'] as Map<String, dynamic>;
      final nightMain = nightSample['main'] as Map<String, dynamic>;
      final dayWeather = daySample['weather'] as List<dynamic>? ?? const [];
      final clouds = daySample['clouds'] as Map<String, dynamic>? ?? const {};
      final wind = daySample['wind'] as Map<String, dynamic>? ?? const {};

      if (dayWeather.isEmpty) {
        throw const FormatException('Прогноз не содержит описания погоды.');
      }

      return WeatherList(
        dt: (daySample['dt'] as num).toInt(),
        sunrise: city.sunrise,
        sunset: city.sunset,
        temp: Temp(
          day: temperature(daySample, 'temp'),
          min: samples
              .map((sample) => temperature(sample, 'temp'))
              .reduce((a, b) => a < b ? a : b),
          max: samples
              .map((sample) => temperature(sample, 'temp'))
              .reduce((a, b) => a > b ? a : b),
          night: (nightMain['temp'] as num).toDouble(),
          eve: (eveningMain['temp'] as num).toDouble(),
          morn: (morningMain['temp'] as num).toDouble(),
        ),
        feelsLike: FeelsLike(
          day: (dayMain['feels_like'] as num).toDouble(),
          night: (nightMain['feels_like'] as num).toDouble(),
          eve: (eveningMain['feels_like'] as num).toDouble(),
          morn: (morningMain['feels_like'] as num).toDouble(),
        ),
        pressure: (dayMain['pressure'] as num).toInt(),
        humidity: (dayMain['humidity'] as num).toInt(),
        weather: dayWeather
            .map((item) => Weather.fromJson(item as Map<String, dynamic>))
            .toList(),
        speed: ((wind['speed'] as num?) ?? 0).toDouble(),
        deg: ((wind['deg'] as num?) ?? 0).toInt(),
        clouds: ((clouds['all'] as num?) ?? 0).toInt(),
      );
    }).toList();

    return WeatherForecast(
      city: city,
      cod: json['cod'].toString(),
      message: ((json['message'] as num?) ?? 0).toDouble(),
      cnt: dailyForecasts.length,
      list: dailyForecasts,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city.toJson();
    data['cod'] = cod;
    data['message'] = message;
    data['cnt'] = cnt;
    if (list != null) {
      data['list'] = list?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  late int id;
  late String name;
  late Coord coord;
  late String country;
  late int population;
  late int timezone;
  int sunrise = 0;
  int sunset = 0;

  City({
    required this.id,
    required this.name,
    required this.coord,
    required this.country,
    required this.population,
    required this.timezone,
    this.sunrise = 0,
    this.sunset = 0,
  });

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coord =
        (json['coord'] != null ? Coord.fromJson(json['coord']) : null) as Coord;
    country = json['country'];
    population = json['population'];
    timezone = json['timezone'];
    sunrise = (json['sunrise'] as num?)?.toInt() ?? 0;
    sunset = (json['sunset'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['coord'] = coord.toJson();
    data['country'] = country;
    data['population'] = population;
    data['timezone'] = timezone;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }
}

class Coord {
  double? lon;
  double? lat;

  Coord({this.lon, this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'].toDouble();
    lat = json['lat'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
    return data;
  }
}

class WeatherList {
  late int dt;
  late int sunrise;
  late int sunset;
  late Temp temp;
  late FeelsLike feelsLike;
  late int pressure;
  late int humidity;
  late List<Weather> weather;
  late double speed;
  late int deg;
  late int clouds;
  //late double rain;

  WeatherList({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.weather,
    required this.speed,
    required this.deg,
    required this.clouds,
    //required this.rain,
  });

  WeatherList.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    temp = (json['temp'] != null ? Temp.fromJson(json['temp']) : null) as Temp;
    feelsLike = (json['feels_like'] != null
        ? FeelsLike.fromJson(json['feels_like'])
        : null) as FeelsLike;
    pressure = json['pressure'];
    humidity = json['humidity'];
    if (json['weather'] != null) {
      weather = [];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
    speed = json['speed'];
    deg = json['deg'];
    clouds = json['clouds'];
    //rain = json['rain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['temp'] = temp.toJson();
    data['feels_like'] = feelsLike.toJson();
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['weather'] = weather.map((v) => v.toJson()).toList();
    data['speed'] = speed;
    data['deg'] = deg;
    data['clouds'] = clouds;
    //data['rain'] = this.rain;
    return data;
  }

  String getIconUrl() {
    return Constants.WEATHER_IMAGES_URL + weather[0].icon + '.png';
  }
}

class Temp {
  late double day;
  late double min;
  late double max;
  late double night;
  late double eve;
  late double morn;

  Temp({
    required this.day,
    required this.min,
    required this.max,
    required this.night,
    required this.eve,
    required this.morn,
  });

  Temp.fromJson(Map<String, dynamic> json) {
    day = json['day'].toDouble();
    min = json['min'].toDouble();
    max = json['max'].toDouble();
    night = json['night'].toDouble();
    eve = json['eve'].toDouble();
    morn = json['morn'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['min'] = min;
    data['max'] = max;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}

class FeelsLike {
  late double day;
  late double night;
  late double eve;
  late double morn;

  FeelsLike({
    required this.day,
    required this.night,
    required this.eve,
    required this.morn,
  });

  FeelsLike.fromJson(Map<String, dynamic> json) {
    day = json['day'].toDouble();
    night = json['night'].toDouble();
    eve = json['eve'].toDouble();
    morn = json['morn'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}

class Weather {
  late int id;
  late String main;
  late String description;
  late String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}
