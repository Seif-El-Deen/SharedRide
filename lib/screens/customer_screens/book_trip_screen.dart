import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/models/car.dart';
import 'package:shared_ride_design_patterns/models/car_owner.dart';
import 'package:shared_ride_design_patterns/models/customer.dart';
import 'package:shared_ride_design_patterns/models/trip.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class BookingScreen extends StatefulWidget {
  final Customer customer;

  static const routeName = "BookingPage";

  const BookingScreen({required this.customer});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<Trip> availableTrips = [];
  List<String> tripsIds = [];
  TimeOfDay? timeToLeave = const TimeOfDay(hour: 7, minute: 15);
  String pickupPoint = "Maadi";
  String destinations = "Giza";
  FirebaseDatabase firebase = FirebaseDatabase.getInstance();
  Trip? acceptedTrip;
  String? acceptedTripRowId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: customerDrawer(context: context),
      backgroundColor: primaryColor,
      body: StreamBuilder(
        stream: firebase.fireStore.collection('Trips').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return loadingWidget();
          } else {
            availableTrips = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              dynamic data = snapshot.data!.docs[i].data();
              print(data);
              // print(timeToLeave);
              // print(pickupPoint);
              // print(destinations);
              if (data['customerName'] == currentCustomer!.userName) {
                acceptedTripRowId = snapshot.data!.docs[i].id;
                acceptedTrip = Trip(
                  data["carOwnerName"],
                  data["carModel"],
                  data["customerName"],
                  data["pickupPoint"],
                  data["destination"],
                  data["tripTime"],
                );
                availableTrips.add(
                  Trip(
                    data["carOwnerName"],
                    data["carModel"],
                    data["customerName"],
                    data["pickupPoint"],
                    data["destination"],
                    data["tripTime"],
                  ),
                );
                break;
              } else if (timeToLeave!.format(context).toString() ==
                      data["tripTime"] &&
                  pickupPoint == data["pickupPoint"] &&
                  destinations == data["destination"] &&
                  data['customerName'] == "notAdded") {
                tripsIds.add(snapshot.data!.docs[i].id);
                availableTrips.add(
                  Trip(
                    data["carOwnerName"],
                    data["carModel"],
                    data["customerName"],
                    data["pickupPoint"],
                    data["destination"],
                    data["tripTime"],
                  ),
                );
              }
            }
            return SafeArea(
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
                              initialTime: timeToLeave!,
                            ) ??
                            const TimeOfDay(hour: 7, minute: 15);
                        setState(() {});
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
                              "Time to leave:  ${timeToLeave!.format(context).toString()}",
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
                              "Destinations: $destinations",
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
                                  destinations = e;
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
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 3, color: Colors.grey)),
                        child: myConditionalBuilder(
                          condition: (availableTrips.isNotEmpty),
                          builder: acceptedTripRowId != ""
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "You have an accepted trip",
                                        style: TextStyle(
                                            fontSize: 28, color: Colors.white),
                                      ),
                                      mySizedBox(),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 130,
                                            height: 130,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/app_icon.png",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  acceptedTrip!.carModel,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  acceptedTrip!.carOwnerName,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.blue,
                                            ),
                                            child: Text(
                                              acceptedTrip!.tripTime,
                                              style:
                                                  const TextStyle(fontSize: 24),
                                            ),
                                          ),
                                        ],
                                      ),
                                      mySizedBox(),
                                      defaultButton(
                                          onTap: () {
                                            firebase.moveTripToTripHistory(
                                                rowId: acceptedTripRowId!,
                                                trip: acceptedTrip!);
                                            acceptedTrip = null;
                                            acceptedTripRowId = "";
                                            setState(() {});
                                          },
                                          text: "Done",
                                          color: Colors.green)
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return searchItem(
                                      trip: availableTrips[index],
                                      index: index,
                                      onTap: () {
                                        firebase
                                            .customerAskedForRide(
                                          carOwnerName: availableTrips[index]
                                              .carOwnerName,
                                          tripId: tripsIds[index],
                                        )
                                            .then((value) {
                                          availableTrips.removeAt(index);
                                          showSnackBar(context,
                                              "Request sent Successfully",
                                              color: Colors.blue);
                                        });

                                        setState(() {});
                                      },
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                  itemCount: availableTrips.length,
                                ),
                          fallback: Center(
                            child: availableTrips.isEmpty
                                ? const Text(
                                    'Enter value to search for',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar:
          bottomNavigationBar(context: context, selectedIndex: 1),
    );
  }

  Widget searchItem(
      {required Trip trip,
      required int index,
      required void Function() onTap}) {
    return StreamBuilder<QuerySnapshot>(
        stream: firebase.fireStore.collection('carOwners').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              dynamic data = snapshot.data!.docs[i].data();

              // if (trip.carOwner.id == snapshot.data!.docs[i].id) {
              //   trip.carOwner.userName = data["username"];
              //   trip.carOwner.email = data["email"];
              //   trip.carOwner.car.type = data["carType"];
              //   trip.carOwner.car.plateNumber = data["carPlateNumber"];
              //   trip.carOwner.car.model = data["carModel"];
              //   trip.carOwner.car.color = data["carColor"];
              //   break;
              // }
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/app_icon.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      mySizedBox(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.carModel,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[700],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              trip.carOwnerName,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.brown[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.blue,
                        ),
                        child: Text(
                          trip.tripTime,
                          style: const TextStyle(fontSize: 24),
                        ),
                      )
                    ],
                  ),
                  defaultButton(
                    onTap: onTap,
                    text: "Ask for a ride",
                    color: Colors.green,
                    width: 200,
                  )
                ],
              ),
            );
          } else {
            return loadingWidget();
          }
        });
  }
}
