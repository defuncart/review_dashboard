import 'dart:math';

import 'package:reviews_dashboard/models/review.dart';

abstract class ILocationService {
  Location get location;
}

class RandomLocationService implements ILocationService {
  final _random = Random();

  @override
  Location get location => Location(
        latitude: _random.nextDoubleInRange(-90, 90),
        longitude: _random.nextDoubleInRange(-180, 180),
      );
}

extension on Random {
  double nextDoubleInRange(num min, num max) => min + nextDouble() * (max - min);
}
