// Slide: StreamBuilder = a screen watching a conveyor belt.
// Every new item on the belt (a Weather) redraws the card. No refresh button.
// Demonstrates: Stream + async* + StreamBuilder.
import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

class LiveWeatherScreen extends StatefulWidget {
  // openStream can be swapped in tests, so no real network is needed.
  const LiveWeatherScreen({super.key, this.openStream = weatherStream});

  final Stream<Weather> Function() openStream;

  @override
  State<LiveWeatherScreen> createState() => _LiveWeatherScreenState();
}

class _LiveWeatherScreenState extends State<LiveWeatherScreen> {
  late final Stream<Weather> _stream;

  @override
  void initState() {
    super.initState();
    // Start the conveyor belt ONCE. Creating it inside build() would start a
    // new belt (and a new polling loop) on every rebuild.
    _stream = widget.openStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Weather>(
      stream: _stream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(child: Text('Weather error: ${snap.error}'));
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final weather = snap.data!;
        return Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Legazpi',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${weather.temp.toStringAsFixed(1)} °C',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Wind: ${weather.wind.toStringAsFixed(1)} km/h'),
                  const SizedBox(height: 12),
                  // Changes every ~5 s so students can SEE the stream working.
                  Text(
                    'Updated ${_hhmmss(DateTime.now())}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Tiny formatter so we don't need the intl package: 9:05:03 -> "09:05:03".
  String _hhmmss(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }
}
