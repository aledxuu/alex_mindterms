// Template: an AppBar with a TabBar over a TabBarView. Layout only, no data.
// DefaultTabController links the TabBar (buttons) to the TabBarView (pages).
import 'package:flutter/material.dart';

class TabbedTemplate extends StatelessWidget {
  const TabbedTemplate({
    super.key,
    required this.title,
    required this.tabLabels,
    required this.tabViews,
  });

  final String title;
  final List<String> tabLabels;
  final List<Widget> tabViews;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLabels.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(tabs: [for (final l in tabLabels) Tab(text: l)]),
        ),
        body: TabBarView(children: tabViews),
      ),
    );
  }
}
