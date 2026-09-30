import 'package:flutter/material.dart';

import '../../models/weather.dart';

// Molecule: the big temperature number with the wind line under it.
class WeatherReadout extends StatelessWidget {
  const WeatherReadout({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${weather.temp.toStringAsFixed(1)} °C',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text('Wind: ${weather.wind.toStringAsFixed(1)} km/h'),
      ],
    );
  }
}
