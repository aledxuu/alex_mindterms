# future_stream_demo

Teaching sample for the lecture **Future, Stream & REST API Integration**.

- **Part 1**: six pure-Dart examples in [dart_examples/](dart_examples/) (no Flutter needed).
- **Part 2 + Live Build**: a Flutter app, *Two-Tab Live App*, with a **Posts** tab
  (`FutureBuilder`) and a **Weather** tab (`StreamBuilder`).

Only one extra dependency: [`http`](https://pub.dev/packages/http). No state management packages, no code generation.

## How to run

```bash
flutter pub get

# Part 1: any file, from the project root
dart run dart_examples/01_future_basics.dart

# Part 2: the app (pick a device with `flutter devices`)
flutter run

# Tests (no real network is used)
flutter analyze
flutter test
```

> **Platform note:** Android needs the `INTERNET` permission in the *main*
> `android/app/src/main/AndroidManifest.xml` (already added; `flutter create` only
> puts it in the debug/profile manifests). macOS builds also need the
> `com.apple.security.network.client` entitlement, which this project does not add.

## File to slide map

| File | Lecture slide / concept |
|------|-------------------------|
| `dart_examples/01_future_basics.dart` | Future = a food order; `async` / `await` |
| `dart_examples/02_errors_timeouts.dart` | `.timeout()`, `try` / `on TimeoutException` / `catch` / `finally` |
| `dart_examples/03_predict_order.dart` | Predict the order: `.then` chain vs. an un-awaited call |
| `dart_examples/04_streams.dart` | Stream = conveyor belt; `async*` + `yield`; `listen()` vs. `await for` |
| `dart_examples/05_transform_streams.dart` | `where` / `map` / `take` on a stream |
| `dart_examples/06_stream_controller.dart` | `StreamController`: `add`, `addError`, `close` |
| `lib/models/post.dart` | `Post.fromJson`: JSON to typed object |
| `lib/models/weather.dart` | `Weather.fromJson`: reading nested JSON (`json['current']`) |
| `lib/services/post_service.dart` | `fetchPosts()`: REST GET, status check, timeout |
| `lib/services/weather_service.dart` | `fetchWeather()` and `weatherStream()` (`async*` polling loop) |
| `lib/screens/posts_screen.dart` | FutureBuilder = status board; the four snapshot branches; `_retry` |
| `lib/screens/live_weather_screen.dart` | StreamBuilder; create the Stream once |
| `lib/screens/home_screen.dart` | `DefaultTabController`, two tabs |
| `test/posts_screen_test.dart` | Testing a FutureBuilder with a fake `loadPosts` |
| `test/live_weather_screen_test.dart` | Testing a StreamBuilder with a `StreamController` |

## Break it on purpose

1. **Airplane mode.** Turn the network off, then open the app (or tap *Retry* on the Posts tab).
   Posts shows the error branch and the Retry button. Turn the network on, tap Retry, and the list appears.
   On the Weather tab notice something different: the spinner just keeps spinning.
   Why? `weatherStream()` swallows errors on purpose (see below), so the StreamBuilder never sees them.
2. **Remove the INTERNET permission.** Delete the `<uses-permission ... INTERNET />` line from the
   *main* `AndroidManifest.xml`, then run `flutter run --release` on an Android device.
   Debug builds still work (the debug manifest has the permission), but the release build can't reach
   the network. This is a classic "works on my machine" bug.
3. **Call `fetchPosts()` inside `build()`.** In `posts_screen.dart`, change
   `future: _postsFuture` to `future: fetchPosts()` and watch the console or network log.
   Every rebuild (for example, resizing the window) sends a new request, and the status board flickers.
   That is why the Future is created once, in `initState`.
4. **Try `setState(() => _postsFuture = ...)` with an arrow.** In `_retry`, replace the `{ }` block
   with `=>`. Flutter asserts "setState() callback argument returned a Future", because an assignment
   evaluates to the value it assigned.
5. **Move the try/catch out of the loop.** In `weatherStream()`, put the `try`/`catch` around the whole
   `while` loop. The first failed request ends the stream for good; an uncaught exception inside `async*` closes it.

## Follow-up topic: switching tabs recreates each tab's State

`TabBarView` only keeps the visible tab alive. When you switch away, that tab's `State` is disposed;
when you come back, a **new** `State` is created and `initState` runs again. We checked this with a test:

- **Weather**: the stream is opened again, so polling restarts and the spinner shows until the first reply.
- **Posts**: `fetchPosts()` runs again, so the list reloads on every visit.

Discussion starters: `AutomaticKeepAliveClientMixin`, or lifting the Future/Stream above the `TabBarView`.

## Things to point out to students

- `weatherStream()` never emits errors: the `catch (_) {}` hides them so the loop survives.
  That means the StreamBuilder's `hasError` branch is only reachable with another stream
  (which is exactly what the test does). Ask: *is silent failure what we want in a real app?*
- The **Updated HH:mm:ss** line is the time the card was drawn, not a server timestamp.
- Open-Meteo rounds coordinates to its own grid, so Legazpi (13.14, 123.74) comes back as roughly 13.11, 123.77. That's normal.

## Stretch ideas

- **Pull-to-refresh** on the Posts list with `RefreshIndicator` (reuse `_retry`; return the new Future).
- **Detail screen** via `GET /posts/{id}`: tap a `ListTile`, push a new screen with its own `FutureBuilder`.
- **Adjustable polling interval**: a `Slider` or dropdown that changes the 5 s delay (hint: `weatherStream(Duration every)` and a new stream when it changes).
- Keep tab state alive (see above), or add a manual "refresh now" button on the Weather card.
