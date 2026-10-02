import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Включите геолокацию в настройках эмулятора.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Разрешите доступ к геолокации в настройках приложения.',
      );
    }
    if (permission == LocationPermission.denied) {
      throw Exception('Для прогноза погоды нужно разрешение на геолокацию.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 15),
      ),
    );
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
