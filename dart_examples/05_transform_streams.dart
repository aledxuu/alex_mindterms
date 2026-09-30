// Slide: "Transform streams".
// Stations along the conveyor belt: each one filters or changes the items.
//
// Run: dart run dart_examples/05_transform_streams.dart

void main() {
  Stream.fromIterable([1, 2, 3, 4, 5, 6])
      .where((n) => n.isEven) //  keep 2, 4, 6
      .map((n) => n * 10) //      turn them into 20, 40, 60
      .take(2) //                 only the first 2, then close the stream
      .listen(print); //          print each one that reaches the end
}

// Expected output:
//   20
//   40
