import 'package:shared_ride_design_patterns/models/car.dart';
import 'package:shared_ride_design_patterns/models/car_owner.dart';
import 'package:shared_ride_design_patterns/models/customer.dart';
import 'package:shared_ride_design_patterns/models/employee.dart';
import 'package:shared_ride_design_patterns/models/person.dart';

class PersonFactory {
  static Person getPerson(
      {required String personType,
      String id = "000",
      String? username,
      String? email,
      String? password,
      String age = "0",
      Car? car}) {
    switch (personType) {
      case "Customer":
        return Customer(
            id: id,
            userName: username!,
            email: email!,
            password: password!,
            age: age);
      case "Employee":
        return Employee(
            id: id,
            userName: username!,
            email: email!,
            password: password!,
            age: age);
      case "Car Owner":
        return CarOwner(
            id: id,
            userName: username!,
            email: email!,
            password: password!,
            age: age,
            car: car!);
      default:
        return Customer(
            id: id,
            userName: username!,
            email: email!,
            password: password!,
            age: age);
    }
  }
}
