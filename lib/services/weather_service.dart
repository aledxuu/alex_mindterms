import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather.dart';

// One-off request: current weather in Legazpi (no API key needed).
Future<Weather> fetchWeather() async {
  final response = await http
      .get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast'
          '?latitude=13.14&longitude=123.74'
          '&current=temperature_2m,wind_speed_10m',
        ),
      )
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception('Server replied ${response.statusCode}');
  }

  return Weather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

// A conveyor belt that puts a fresh Weather on it every 5 seconds.
Stream<Weather> weatherStream() async* {
  while (true) {
    // The try/catch MUST live inside the loop: an uncaught exception inside
    // async* ENDS the stream. Here one failed request just skips a turn.
    try {
      yield await fetchWeather();
    } catch (_) {}
    await Future.delayed(const Duration(seconds: 5));
  }
}
