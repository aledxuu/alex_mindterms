// Slide: "Future = a food order".
// You place the order now, the burger arrives later. `await` = wait at the counter.
//
// Run: dart run dart_examples/01_future_basics.dart

// A Future<String> is a promise: "a String will arrive later".
Future<String> cookBurger() async {
  print('Kitchen: cooking...');
  await Future.delayed(const Duration(seconds: 2)); // pretend cooking takes 2 s
  return 'Burger';
}

Future<void> main() async {
  print('Order placed');
  final burger = await cookBurger(); // pause here until the burger is ready
  print('Served: $burger');
}

// Expected output:
//   Order placed
//   Kitchen: cooking...
//   (2 second pause)
//   Served: Burger
