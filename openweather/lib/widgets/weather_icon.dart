import 'package:flutter/material.dart';

IconData weatherIconFor(String? condition) {
  switch (condition?.toLowerCase()) {
    case 'clear':
      return Icons.wb_sunny_rounded;
    case 'clouds':
      return Icons.cloud_rounded;
    case 'rain':
    case 'drizzle':
      return Icons.umbrella_rounded;
    case 'thunderstorm':
      return Icons.thunderstorm_rounded;
    case 'snow':
      return Icons.ac_unit_rounded;
    default:
      return Icons.cloud_rounded;
  }
}
