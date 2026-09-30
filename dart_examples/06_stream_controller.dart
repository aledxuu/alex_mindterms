// Slide: "StreamController = build your own belt".
// You decide what goes on the belt: add() for items, addError() for a problem,
// close() when there is nothing more to send.
//
// Run: dart run dart_examples/06_stream_controller.dart

import 'dart:async';

Future<void> main() async {
  final controller = StreamController<String>();

  // The listener is the person at the end of the belt.
  controller.stream.listen(
    (msg) => print('Got: $msg'),
    onError: (Object e) => print('Error: $e'),
    onDone: () => print('Done'),
  );

  controller.add('Hello');
  controller.add('World');
  controller.addError(Exception('Sensor failed'));
  await controller.close(); // no more items; listener's onDone will fire
}

// Expected output:
//   Got: Hello
//   Got: World
//   Error: Exception: Sensor failed
//   Done
