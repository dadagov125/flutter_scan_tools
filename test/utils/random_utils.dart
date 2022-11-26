import 'dart:math';

int randomRange(int min, int max) {
  return min + Random().nextInt(max - min);
}
