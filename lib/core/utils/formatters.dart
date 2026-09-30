// Tiny formatter so we don't need the intl package: 9:05:03 -> "09:05:03".
String hhmmss(DateTime t) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}
