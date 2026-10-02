import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Util {
  static String getFormattedDate(DateTime dateTime) {
    return DateFormat('EEE, MMM d, y').format(dateTime);
  }

  static Widget getItem(FaIconData iconData, int value, String units) {
    return Column(
      children: <Widget>[
        FaIcon(iconData, color: Colors.black87, size: 28.0),
        const SizedBox(height: 10.0),
        Text(
          '$value',
          style: const TextStyle(fontSize: 20.0, color: Colors.black87),
        ),
        const SizedBox(height: 10.0),
        Text(
          units,
          style: const TextStyle(fontSize: 15.0, color: Colors.black87),
        ),
      ],
    );
  }
}
