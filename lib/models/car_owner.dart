import 'package:shared_ride_design_patterns/models/car.dart';
import 'package:shared_ride_design_patterns/models/prototype.dart';
import 'package:shared_ride_design_patterns/models/person.dart';

class CarOwner extends Person implements PrototypeInterface {
  late Car _car;

  Car get car => _car;

  set car(Car value) {
    _car = value;
  }

  CarOwner(
      {required super.id,
      required super.userName,
      required super.email,
      required super.password,
      required super.age,
      required car}) {
    _car = car;
  }

  @override
  PrototypeInterface getClone() {
    return CarOwner(
        id: id,
        userName: userName,
        email: email,
        password: password,
        age: age,
        car: car);
  }
}
