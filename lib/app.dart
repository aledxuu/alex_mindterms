import 'package:flutter/material.dart';

import 'ui/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future & Stream Demo',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const HomePage(),
    );
  }
}
