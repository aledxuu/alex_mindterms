// Slide: "Stream = a conveyor belt".
// A Future gives ONE value later. A Stream gives MANY values over time.
//
// Run: dart run dart_examples/04_streams.dart

import 'dart:async';

// async* + yield = a function that puts items on the belt, one at a time.
Stream<int> countdown(int from) async* {
  for (var i = from; i >= 1; i--) {
    await Future.delayed(const Duration(seconds: 1));
    yield i; // put [i] on the belt, then keep going
  }
}

Future<void> main() async {
  // Way 1: listen() with three callbacks: data, error, done.
  print('--- Way 1: listen() ---');
  final finished = Completer<void>(); // lets main() wait until the belt stops
  countdown(3).listen(
    (n) => print(n), // a new item arrived
    onError: (Object e) => print('Error: $e'), // never fires here, but it could
    onDone: () {
      print('Liftoff! (done)');
      finished.complete();
    },
  );
  await finished.future;

  // Way 2: await for. Reads like a normal loop, one item per turn.
  print('--- Way 2: await for ---');
  await for (final n in countdown(3)) {
    print(n);
  }
  print('Liftoff!');
}

// Expected output:
//   --- Way 1: listen() ---
//   3
//   2
//   1
//   Liftoff! (done)
//   --- Way 2: await for ---
//   3
//   2
//   1
//   Liftoff!
// (each number appears 1 second after the previous one)
