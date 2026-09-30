// Slide: "Futures can fail or be too slow".
// The kitchen may burn the burger (error) or take too long (timeout).
//
// Run: dart run dart_examples/02_errors_timeouts.dart

import 'dart:async'; // TimeoutException lives here

// This kitchen always fails, but only after 3 seconds.
Future<String> cookBurger() async {
  await Future.delayed(const Duration(seconds: 3));
  throw Exception('Kitchen is on fire!');
}

// [patience] = how long the customer is willing to wait.
Future<void> placeOrder(String label, Duration patience) async {
  print('$label: order placed');
  try {
    final burger = await cookBurger().timeout(patience);
    print('$label: served $burger');
  } on TimeoutException {
    // Most specific catch goes first: we gave up waiting.
    print('$label: too slow, customer left');
  } catch (e) {
    // Anything else: the Future itself failed.
    print('$label: kitchen error -> $e');
  } finally {
    // Runs no matter what: success, timeout or error.
    print('$label: order closed');
  }
}

Future<void> main() async {
  // Customer 1 waits 2 s, but the kitchen needs 3 s -> TimeoutException.
  await placeOrder('Order 1', const Duration(seconds: 2));
  // Customer 2 waits 5 s -> sees the kitchen's own error at 3 s.
  await placeOrder('Order 2', const Duration(seconds: 5));
}

// Expected output:
//   Order 1: order placed
//   (2 second pause)
//   Order 1: too slow, customer left
//   Order 1: order closed
//   Order 2: order placed
//   (3 second pause)
//   Order 2: kitchen error -> Exception: Kitchen is on fire!
//   Order 2: order closed
