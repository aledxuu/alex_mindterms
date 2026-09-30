// Slide: "Putting it together": two tabs, one Future and one Stream.
// DefaultTabController links the TabBar (buttons) to the TabBarView (pages).
import 'package:flutter/material.dart';

import 'live_weather_screen.dart';
import 'posts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Two-Tab Live App'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Weather'),
            ],
          ),
        ),
        body: const TabBarView(children: [PostsScreen(), LiveWeatherScreen()]),
      ),
    );
  }
}
