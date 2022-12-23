import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/models/car_owner.dart';
import 'package:shared_ride_design_patterns/models/customer.dart';
import 'package:shared_ride_design_patterns/models/employee.dart';

const List<String> locations = [
  "City Stars",
  "Giza",
  "New Cairo",
  "Maadi",
  "Roxy",
  "Downtown "
];

const List<String> usersRole = ["Customer", "Car Owner", "Employee"];

Customer? currentCustomer;

CarOwner? currentCarOwner;

Employee? currentEmployee;
