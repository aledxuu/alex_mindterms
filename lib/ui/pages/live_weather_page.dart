// Slide: StreamBuilder = a screen watching a conveyor belt.
// Every new item on the belt (a Weather) redraws the card. No refresh button.
// Demonstrates: Stream + async* + StreamBuilder.
import 'package:flutter/material.dart';

import '../../models/weather.dart';
import '../../services/weather_service.dart';
import '../atoms/loading_spinner.dart';
import '../atoms/message_text.dart';
import '../organisms/weather_card.dart';

class LiveWeatherPage extends StatefulWidget {
  // openStream can be swapped in tests, so no real network is needed.
  const LiveWeatherPage({super.key, this.openStream = weatherStream});

  final Stream<Weather> Function() openStream;

  @override
  State<LiveWeatherPage> createState() => _LiveWeatherPageState();
}

class _LiveWeatherPageState extends State<LiveWeatherPage> {
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
          return MessageText('Weather error: ${snap.error}');
        }
        if (!snap.hasData) {
          return const LoadingSpinner();
        }

        return WeatherCard(
          city: 'Legazpi',
          weather: snap.data!,
          updatedAt: DateTime.now(),
        );
      },
    );
  }
}
