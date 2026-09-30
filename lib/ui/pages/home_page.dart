// Slide: "Putting it together": two tabs, one Future and one Stream.
import 'package:flutter/material.dart';

import '../templates/tabbed_template.dart';
import 'live_weather_page.dart';
import 'posts_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabbedTemplate(
      title: 'Two-Tab Live App',
      tabLabels: ['Posts', 'Weather'],
      tabViews: [PostsPage(), LiveWeatherPage()],
    );
  }
}
