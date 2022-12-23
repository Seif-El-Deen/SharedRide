import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/models/CarTypeFactory.dart';
import 'package:shared_ride_design_patterns/models/PersonFactory.dart';
import 'package:shared_ride_design_patterns/models/car.dart';
import 'package:shared_ride_design_patterns/models/car_owner.dart';
import 'package:shared_ride_design_patterns/models/car_type.dart';
import 'package:shared_ride_design_patterns/models/customer.dart';
import 'package:shared_ride_design_patterns/models/employee.dart';
import 'package:shared_ride_design_patterns/models/person.dart';
import 'package:shared_ride_design_patterns/screens/car_owner_screens/add_trip_screen.dart';
import 'package:shared_ride_design_patterns/screens/customer_screens/profile_screen.dart';
import 'package:shared_ride_design_patterns/screens/employee_screens/view_complaints_screen.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';

class Facade {
  static Future loginUser({
    required BuildContext context,
    required String email,
    required String password,
    required String userType,
  }) async {
    FirebaseDatabase firebase = FirebaseDatabase.getInstance();
    await firebase
        .loginUser(context: context, email: email, password: password)
        .then(
      (value) {
        Person person = PersonFactory.getPerson(
          personType: userType,
          id: "id",
          username: "username",
          email: email,
          password: password,
          age: "age",
          car: Car(
            "_model",
            "_plateNumber",
            CarTypeFactory.getCarType(
              type: "_type",
              numOfSeats: 5,
            ),
            "_color",
            "_industryYear",
          ),
        );
        if (userType == "Customer") {
          navigatePushNamed(
            context: context,
            widget: ProfileScreen(
              customer: person as Customer,
            ),
          );
        } else if (userType == "Car Owner") {
          navigatePushNamed(
            context: context,
            widget: AddTripScreen(
              carOwner: person as CarOwner,
            ),
          );
        } else if (userType == "Employee") {
          currentEmployee = person as Employee;
          navigatePushNamed(
            context: context,
            widget: const ViewCustomerComplaints(),
          );
        }
        showSnackBar(context, "Login Successfully", color: Colors.greenAccent);
      },
    ).catchError((error) {
      showSnackBar(context, error.toString(), color: Colors.red);
    });
  }

  static Future registerUser({
    required BuildContext context,
    required String userRole,
    required String username,
    required String email,
    required String password,
    String? typeOfCar,
    String? carModel,
    String? carPlateNumber,
    String? carColor,
    String? carIndustryYear,
  }) async {
    Person? person;
    Car? car;
    switch (userRole) {
      case "Customer":
        person = Customer(
            id: "000",
            userName: username,
            email: email,
            password: password,
            age: "0");
        break;
      case "Employee":
        person = Employee(
            id: "000",
            userName: username,
            email: email,
            password: password,
            age: "age");
        break;
      case "Car Owner":
        CarType carType = CarTypeFactory.getCarType(
          type: typeOfCar!,
          numOfSeats: typeOfCar == "Sedan" ? 5 : 7,
        );
        car = Car(
            carModel!, carPlateNumber!, carType, carColor!, carIndustryYear!);
        person = CarOwner(
                id: "000",
                userName: username,
                email: email,
                password: password,
                age: "age",
                car: car)
            .getClone() as CarOwner;
        print(carModel);
        print(carPlateNumber);
        print(carType);
        print(carColor);
        print(carIndustryYear);

        break;
    }

    FirebaseDatabase firebase = FirebaseDatabase.getInstance();
    await firebase
        .registerUser(
            context: context, userType: userRole, user: person!, car: car)
        .then((value) {
      switch (userRole) {
        case "Customer":
          navigatePushNamed(
            context: context,
            widget: ProfileScreen(customer: person as Customer),
          );
          break;
        case "Car Owner":
          navigatePushNamed(
            context: context,
            widget: AddTripScreen(carOwner: person as CarOwner),
          );
          break;
        case "Employee":
          currentEmployee = Employee(
                  id: "id",
                  userName: username,
                  email: email,
                  password: password,
                  age: "age")
              .getClone() as Employee;
          navigatePushNamed(
            context: context,
            widget: const ViewCustomerComplaints(),
          );
          break;
      }
    });
  }
}
