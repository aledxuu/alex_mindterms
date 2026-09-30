import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../models/weather.dart';
import '../molecules/weather_readout.dart';

// Organism: the full weather card (city, readout, last-updated time).
class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.city,
    required this.weather,
    required this.updatedAt,
  });

  final String city;
  final Weather weather;
  final DateTime updatedAt;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(city, style: textTheme.headlineSmall),
              const SizedBox(height: 12),
              WeatherReadout(weather: weather),
              const SizedBox(height: 12),
              // Changes every ~5 s so students can SEE the stream working.
              Text('Updated ${hhmmss(updatedAt)}', style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
