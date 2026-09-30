// Slide: "Predict the order".
// Same three prints, two styles. Which order do you get? Guess first, then run it!
//
// Run: dart run dart_examples/03_predict_order.dart

import 'dart:async'; // for unawaited()

Future<void> slowStep() => Future.delayed(const Duration(seconds: 1));

// Version A: .then chain. Each .then is "the next step, after the last one".
Future<void> versionA() {
  print('1');
  return slowStep().then((_) => print('2')).then((_) => print('3'));
}

// Version B: async/await, but the slow work is NOT awaited by its caller.
Future<void> versionB() async {
  print('1');
  // We "forgot" to await, so Dart does not wait: it moves on to print('3').
  // unawaited() says "I know". Delete it and the unawaited_futures lint warns you.
  unawaited(printTwoLater());
  print('3');
}

Future<void> printTwoLater() async {
  await slowStep();
  print('2');
}

Future<void> main() async {
  print('--- Version A (.then) ---');
  await versionA();

  print('--- Version B (await) ---');
  await versionB();
  // Keep the program alive long enough to see the late '2'.
  await Future.delayed(const Duration(seconds: 2));
}

// Expected output:
//   --- Version A (.then) ---
//   1
//   (1 second pause)
//   2
//   3
//   --- Version B (await) ---
//   1
//   3
//   (1 second pause)
//   2
