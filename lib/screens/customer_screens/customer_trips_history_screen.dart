import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/models/trip.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class CustomerTripsHistoryScreen extends StatefulWidget {
  const CustomerTripsHistoryScreen({Key? key}) : super(key: key);
  static const routeName = "CustomerTripsHistoryScreenPage";
  @override
  State<CustomerTripsHistoryScreen> createState() =>
      _CustomerTripsHistoryScreenState();
}

class _CustomerTripsHistoryScreenState
    extends State<CustomerTripsHistoryScreen> {
  FirebaseDatabase firebase = FirebaseDatabase.getInstance();
  List<Trip> historyTrips = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: customerDrawer(context: context),
      backgroundColor: primaryColor,
      body: StreamBuilder(
          stream: firebase.fireStore.collection('TripsHistory').snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              historyTrips = [];

              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                dynamic data = snapshot.data!.docs[i].data();

                if (data['customerName'] == currentCustomer!.userName) {
                  historyTrips.add(
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
              return ListView.separated(
                  itemBuilder: ((context, index) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Car Owner: ${historyTrips[index].carOwnerName}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Car Model: ${historyTrips[index].carModel}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Trip Time: ${historyTrips[index].tripTime}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Pickup Point: ${historyTrips[index].pickupPoint}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Destination Point: ${historyTrips[index].destination}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  separatorBuilder: (context, index) {
                    return myDivider();
                  },
                  itemCount: historyTrips.length);
            } else {
              return loadingWidget();
            }
          })),
      bottomNavigationBar:
          bottomNavigationBar(context: context, selectedIndex: 2),
    );
  }
}
