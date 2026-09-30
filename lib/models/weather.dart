// Current weather from api.open-meteo.com. Temperature in °C, wind in km/h.
class Weather {
  const Weather({required this.temp, required this.wind});

  final double temp;
  final double wind;

  // The API nests the values under "current":
  // { "current": { "temperature_2m": 30.4, "wind_speed_10m": 7.9 }, ... }
  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return Weather(
      // `as num` then toDouble(): the API may send 30 instead of 30.0.
      temp: (current['temperature_2m'] as num).toDouble(),
      wind: (current['wind_speed_10m'] as num).toDouble(),
    );
  }
}
