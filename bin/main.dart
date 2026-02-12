import 'dart:io';

import 'geometry.dart';

void main() {
  print(Thing.parse(GeometryIterator(stdin.readLineSync()!.runes.iterator)));
}