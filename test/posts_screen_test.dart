import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_stream_demo/models/post.dart';
import 'package:future_stream_demo/screens/posts_screen.dart';

const _posts = [
  Post(id: 1, title: 'First post', body: 'Body one'),
  Post(id: 2, title: 'Second post', body: 'Body two'),
];

// Wraps PostsScreen the way HomeScreen would (inside a Scaffold).
Widget _app(Future<List<Post>> Function() loadPosts) {
  return MaterialApp(
    home: Scaffold(body: PostsScreen(loadPosts: loadPosts)),
  );
}

void main() {
  testWidgets('shows a spinner while waiting', (tester) async {
    final completer = Completer<List<Post>>(); // never completed: stays waiting
    await tester.pumpWidget(_app(() => completer.future));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error and Retry works', (tester) async {
    var calls = 0;
    // Fake server: fails the first time, succeeds the second time.
    Future<List<Post>> flaky() async {
      calls++;
      if (calls == 1) throw Exception('boom');
      return _posts;
    }

    await tester.pumpWidget(_app(flaky));
    await tester.pump(); // let the Future finish

    expect(find.textContaining('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump(); // rebuild with the new Future
    await tester.pump(); // let it finish

    expect(find.text('Retry'), findsNothing);
    expect(find.text('First post'), findsOneWidget);
    expect(calls, 2);
  });

  testWidgets('shows message for an empty list', (tester) async {
    await tester.pumpWidget(_app(() async => <Post>[]));
    await tester.pump();

    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  testWidgets('shows post titles when data arrives', (tester) async {
    await tester.pumpWidget(_app(() async => _posts));
    await tester.pump();

    expect(find.text('First post'), findsOneWidget);
    expect(find.text('Second post'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('does not reload when the widget rebuilds', (tester) async {
    var calls = 0;
    Future<List<Post>> counting() async {
      calls++;
      return _posts;
    }

    await tester.pumpWidget(_app(counting));
    await tester.pump();
    await tester.pumpWidget(_app(counting)); // force a rebuild
    await tester.pump();

    expect(calls, 1); // Future was created once, in initState
  });
}
