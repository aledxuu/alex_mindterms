import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_stream_demo/models/weather.dart';
import 'package:future_stream_demo/ui/pages/live_weather_page.dart';

void main() {
  // Our own conveyor belt: the test decides what goes on it and when.
  late StreamController<Weather> controller;

  setUp(() {
    controller = StreamController<Weather>();
    addTearDown(controller.close);
  });

  Future<void> pumpScreen(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LiveWeatherPage(openStream: () => controller.stream),
        ),
      ),
    );
  }

  testWidgets('shows a spinner before the first event', (tester) async {
    await pumpScreen(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Legazpi'), findsNothing);
  });

  testWidgets('shows the weather card after add()', (tester) async {
    await pumpScreen(tester);

    controller.add(const Weather(temp: 30.4, wind: 7.9));
    await tester.pump();

    expect(find.text('Legazpi'), findsOneWidget);
    expect(find.text('30.4 °C'), findsOneWidget);
    expect(find.text('Wind: 7.9 km/h'), findsOneWidget);
    expect(find.textContaining('Updated'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows error text after addError()', (tester) async {
    await pumpScreen(tester);

    controller.addError(Exception('no signal'));
    await tester.pump();

    expect(find.textContaining('Weather error'), findsOneWidget);
    expect(find.textContaining('no signal'), findsOneWidget);
  });
}
