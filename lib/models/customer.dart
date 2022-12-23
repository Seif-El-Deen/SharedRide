import 'package:shared_ride_design_patterns/models/prototype.dart';
import 'package:shared_ride_design_patterns/models/person.dart';

class Customer extends Person implements PrototypeInterface {
  Customer(
      {required super.id,
      required super.userName,
      required super.email,
      required super.password,
      required super.age});

  @override
  PrototypeInterface getClone() {
    return Customer(
      id: id,
      userName: userName,
      email: email,
      password: password,
      age: age,
    );
  }
}
