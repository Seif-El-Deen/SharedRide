import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/models/customer.dart';
import 'package:shared_ride_design_patterns/screens/login_screen.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class TripRequestsScreen extends StatefulWidget {
  const TripRequestsScreen({Key? key}) : super(key: key);

  static const routeName = "TripRequestsPage";

  @override
  State<TripRequestsScreen> createState() => _TripRequestsScreenState();
}

class _TripRequestsScreenState extends State<TripRequestsScreen> {
  FirebaseDatabase firebase = FirebaseDatabase.getInstance();

  List<Customer> availableRides = [];
  List<String> rowsIds = [];
  List<String> tripsIds = [];

  // String carOwnerId = "";
  bool tripAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: carOwnerDrawer(context: context),
      backgroundColor: primaryColor,
      body: StreamBuilder(
        stream: firebase.fireStore.collection('AskedForRide').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            availableRides = [];
            rowsIds = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              dynamic data = snapshot.data!.docs[i].data();
              // print(data);
              if (currentCarOwner!.userName == data["carOwnerName"]) {
                // carOwnerId = data["carOwnerId"];
                availableRides.add(
                  Customer(
                    id: "data[customer]",
                    userName: data["customerName"],
                    email: "email",
                    password: "password",
                    age: "age",
                  ),
                );
                tripsIds.add(data["tripId"]);
                rowsIds.add(snapshot.data!.docs[i].id);
              }
            }

            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: myConditionalBuilder(
                  condition: availableRides.isNotEmpty,
                  builder: ListView.separated(
                      itemBuilder: (context, index) {
                        return customerData(
                          tripId: tripsIds[index],
                          customerName: availableRides[index].userName,
                          rowId: rowsIds[index],
                        );
                      },
                      separatorBuilder: (context, index) => myDivider(),
                      itemCount: availableRides.length),
                  fallback: const Center(
                    child: Text(
                      "No Available Ride Requests",
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return loadingWidget();
          }
        },
      ),
      bottomNavigationBar:
          carOwnerBottomNavigationBar(context: context, selectedIndex: 0),
    );
  }

  Widget customerData(
      {required String customerName,
      required String rowId,
      required String tripId}) {
    String customerEmail = "";
    return StreamBuilder(
      stream: firebase.fireStore.collection('Customers').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return loadingWidget();
        } else {
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            dynamic data = snapshot.data!.docs[i].data();

            if (data['username'] == customerName) {
              // print("inner Data: $data");
              customerEmail = data["email"];
              break;
            }
          }
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                      radius: 50,
                      child: Image.asset(
                        "assets/images/profile.png",
                        width: 80,
                        height: 80,
                      )),
                ),
                // const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Text(
                        "Username: $customerName",
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Email: $customerEmail",
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
                // const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          firebase.updateTripCustomer(
                            customerName: customerName,
                            tripId: tripId,
                            rowId: rowId,
                          );
                          firebase.deleteAskedForRideRow(rowId: rowId);
                        },
                        icon: const Icon(
                          Icons.check_box,
                          color: Colors.green,
                          size: 50,
                        ),
                      ),
                      mySizedBox(),
                      IconButton(
                        onPressed: () {
                          firebase.deleteAskedForRideRow(rowId: rowId);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
