import 'dart:math';

import 'package:semaforo_inteligente/models/index_enum.dart';

IndexEnum trafficIndex(int x, int y) {
  if (x == y) {
    return IndexEnum.equal;
  }
  int highest = max(x, y);
  int diff;
  if (highest == x) {
    diff = x - y;
    print(diff);
    return getXIndex(diff);
  } else {
    diff = y - x;
    print(diff);
    return getYIndex(diff);
  }
}

getXIndex(value) {
  if (value < 2) return IndexEnum.equal;
  if (value < 6) return IndexEnum.minorXBias;
  if (value < 12) return IndexEnum.moderateXBias;
  if (value < 18) return IndexEnum.highXBias;
  return IndexEnum.extremeXBias;
}

getYIndex(value) {
  if (value < 2) return IndexEnum.equal;
  if (value < 6) return IndexEnum.minorYBias;
  if (value < 12) return IndexEnum.moderateYBias;
  if (value < 18) return IndexEnum.highYBias;
  return IndexEnum.extremeYBias;
}
