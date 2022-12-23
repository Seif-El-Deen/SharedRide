import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/screens/car_owner_screens/add_trip_screen.dart';
import 'package:shared_ride_design_patterns/screens/car_owner_screens/car_owner_trips_history_screen.dart';
import 'package:shared_ride_design_patterns/screens/car_owner_screens/trip_requests_screen.dart';
import 'package:shared_ride_design_patterns/screens/customer_screens/book_trip_screen.dart';
import 'package:shared_ride_design_patterns/screens/customer_screens/profile_screen.dart';
import 'package:shared_ride_design_patterns/screens/customer_screens/customer_trips_history_screen.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';

void showSnackBar(BuildContext context, String message,
    {Color color = Colors.grey}) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}

void navigateWithReplacement(
    {required BuildContext context, required String routeName}) {
  Navigator.pushReplacementNamed(context, routeName);
}

void navigatePushNamed(
    {required BuildContext context, required Widget widget}) {
  Navigator.pop(context);
  Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => widget));
}

// void navigate({required BuildContext context, required String routeName}) {
//   Navigator.pop(context);
//   Navigator.push();
// }

Widget myConditionalBuilder(
    {required bool condition,
    required Widget builder,
    required Widget fallback}) {
  return condition ? builder : fallback;
}

void customerBottomNavigationBarNavigation(
    {required BuildContext context, required int index}) {
  switch (index) {
    case 0:
      navigatePushNamed(
          context: context, widget: ProfileScreen(customer: currentCustomer!));
      // navigateWithReplacement(
      //     context: context, routeName: ProfileScreen.routeName);
      break;
    case 1:
      navigatePushNamed(
          context: context, widget: BookingScreen(customer: currentCustomer!));
      // navigateWithReplacement(
      //     context: context, routeName: BookingScreen.routeName);
      break;
    case 2:
      navigateWithReplacement(
          context: context, routeName: CustomerTripsHistoryScreen.routeName);
      break;
  }
}

void carOwnerBottomNavigationBarNavigation(
    {required BuildContext context, required int index}) {
  switch (index) {
    case 0:
      navigateWithReplacement(
          context: context, routeName: TripRequestsScreen.routeName);
      break;
    case 1:
      navigateWithReplacement(
          context: context, routeName: AddTripScreen.routeName);
      break;
    case 2:
      navigateWithReplacement(
          context: context, routeName: CarOwnerTripsHistoryScreen.routeName);
      break;
  }
}
