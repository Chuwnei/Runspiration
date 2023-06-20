import 'dart:math';

List<String> quotes = [
  "Running is a gift. Enjoy every step and every breath.",
  "You have the power to overcome any obstacle. Just keep moving forward.",
  "Every run is a victory. Celebrate your progress and your potential.",
  "You are not alone. You have a whole community of runners cheering you on.",
  "Running is not a chore. It’s an opportunity to discover yourself and the world around you."
];

String getQuote() {
  return quotes[Random().nextInt(quotes.length)];
}
