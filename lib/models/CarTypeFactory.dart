import 'package:shared_ride_design_patterns/models/car_type.dart';

// Fly Weight pattern used to reduce
class CarTypeFactory {
  static final Map<String, CarType> _carTypes = Map();

  static CarType getCarType({required String type, required int numOfSeats}) {
    if (_carTypes.containsKey(type)) {
      return _carTypes[type]!;
    } else {
      _carTypes[type] = CarType(type, numOfSeats);

      return _carTypes[type]!;
    }
  }
}
