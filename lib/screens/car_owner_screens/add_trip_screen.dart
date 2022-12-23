import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/models/CarTypeFactory.dart';
import 'package:shared_ride_design_patterns/models/car.dart';
import 'package:shared_ride_design_patterns/models/car_owner.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class AddTripScreen extends StatefulWidget {
  static const routeName = "AddTripPage";

  AddTripScreen({required this.carOwner});

  CarOwner carOwner;

  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  TimeOfDay timeToLeave = const TimeOfDay(hour: 7, minute: 15);

  String pickupPoint = "Maadi";
  String destination = "Giza";

  FirebaseDatabase firebase = FirebaseDatabase.getInstance();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebase.fireStore.collection('carOwners').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingWidget();
          } else {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              dynamic data = snapshot.data!.docs[i].data();
              if (widget.carOwner.email == data["email"] &&
                  widget.carOwner.password == data["password"]) {
                // print(snapshot.data!.docs[i].id);
                currentCarOwner = CarOwner(
                        id: snapshot.data!.docs[i].id,
                        userName: data["username"],
                        email: data["email"],
                        password: data["password"],
                        age: "age",
                        car: Car(
                            data["carModel"],
                            data["carPlateNumber"],
                            CarTypeFactory.getCarType(
                              type: data["carType"],
                              numOfSeats: data["carType"] == "Sedan" ? 5 : 8,
                            ),
                            data["carColor"],
                            data["carIndustryYear"]))
                    .getClone() as CarOwner?;
              }
            }
            return Scaffold(
              appBar: AppBar(),
              drawer: carOwnerDrawer(context: context),
              backgroundColor: primaryColor,
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          timeToLeave = await showTimePicker(
                                context: context,
                                initialTime: timeToLeave,
                              ) ??
                              const TimeOfDay(hour: 7, minute: 15);
                          // print(timeToLeave!.period.toString());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.timer,
                                size: 34,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Time to leave:  ${timeToLeave.format(context).toString()}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      mySizedBox(),
                      PopupMenuButton(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on_sharp,
                                size: 34,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Pickup Point: $pickupPoint",
                                style: const TextStyle(fontSize: 28),
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (BuildContext context) {
                          return locations
                              .map(
                                (e) => PopupMenuItem(
                                  value: e,
                                  onTap: () {
                                    pickupPoint = e;
                                    setState(() {});
                                  },
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                              .toList();
                        },
                      ),
                      mySizedBox(),
                      PopupMenuButton(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on_sharp,
                                size: 34,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Destinations: $destination",
                                style: const TextStyle(fontSize: 28),
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (BuildContext context) {
                          return locations
                              .map(
                                (e) => PopupMenuItem(
                                  value: e,
                                  onTap: () {
                                    destination = e;
                                    setState(() {});
                                  },
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                              .toList();
                        },
                      ),
                      myDivider(thickness: 3, height: 20),
                      defaultButton(
                          onTap: () async {
                            await firebase
                                .carOwnerAddTrip(
                                    pickupPoint: pickupPoint,
                                    destination: destination,
                                    tripTime:
                                        timeToLeave.format(context).toString())
                                .then(
                              (value) {
                                showSnackBar(context, "Trip Added Successfully",
                                    color: Colors.lightGreenAccent);
                              },
                            );
                          },
                          text: "Add Trip"),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: carOwnerBottomNavigationBar(
                  context: context, selectedIndex: 1),
            );
          }
        });
  }
}
