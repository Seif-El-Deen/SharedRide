import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/screens/car_owner_screens/add_trip_screen.dart';
import 'package:shared_ride_design_patterns/screens/car_owner_screens/car_owner_trips_history_screen.dart';
import 'package:shared_ride_design_patterns/screens/car_owner_screens/trip_requests_screen.dart';
import 'package:shared_ride_design_patterns/screens/customer_screens/customer_trips_history_screen.dart';
import 'package:shared_ride_design_patterns/screens/login_screen.dart';
import 'package:shared_ride_design_patterns/screens/register_screen.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Ride',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: primaryColor,
        primaryColor: primaryColor,
        fontFamily: 'pacifico',
        // fontFamily: "Varela_Round",
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (BuildContext context) => const LoginPage(),
        RegisterPage.routeName: (BuildContext context) => const RegisterPage(),
        TripRequestsScreen.routeName: (BuildContext context) =>
            const TripRequestsScreen(),
        CustomerTripsHistoryScreen.routeName: (BuildContext context) =>
            const CustomerTripsHistoryScreen(),
        CarOwnerTripsHistoryScreen.routeName: (BuildContext context) =>
            const CarOwnerTripsHistoryScreen(),
        AddTripScreen.routeName: (BuildContext context) =>
            AddTripScreen(carOwner: currentCarOwner!),

        // ProfileScreen.routeName: (BuildContext context) => ProfileScreen(
        //     customer: Customer(
        //         id: "2",
        //         userName: "Mohamed Mahmoud",
        //         email: "mohamedmahmoud@gmail.com",
        //         password: "mohamed1234",
        //         age: "23")),
        // BookingScreen.routeName: (BuildContext context) => BookingScreen(
        //       Customer(
        //           id: "2",
        //           userName: "Mohamed Mahmoud",
        //           email: "mohamedmahmoud@gmail.com",
        //           password: "mohamed1234",
        //           age: "23"),
        //     ),
      },
    );
  }
}
