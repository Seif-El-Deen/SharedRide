import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class RateDriverScreen extends StatefulWidget {
  const RateDriverScreen({Key? key}) : super(key: key);

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  FirebaseDatabase firebase = FirebaseDatabase.getInstance();

  List<String> carOwners = [];
  String carOwnerName = "";
  double rate = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(),
      body: StreamBuilder(
          stream: firebase.fireStore.collection('TripsHistory').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              carOwners = [];

              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                dynamic data = snapshot.data!.docs[i].data();
                if (data['customerName'] == currentCustomer!.userName) {
                  if (!carOwners.contains(data["carOwnerName"])) {
                    carOwners.add(data["carOwnerName"]);
                  }
                }
              }
              return SafeArea(
                  child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
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
                              "Car Owner Name: $carOwnerName",
                              style: const TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (BuildContext context) {
                        return carOwners
                            .map(
                              (e) => PopupMenuItem(
                                value: e,
                                onTap: () {
                                  carOwnerName = e;
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
                    mySizedBox(),
                    RatingBar(
                      initialRating: rate,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.yellow),
                        half: const Icon(Icons.star_half, color: Colors.yellow),
                        empty: const Icon(Icons.star, color: Colors.grey),
                      ),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (rating) {
                        rate = rating;

                        print(rating);
                      },
                    ),
                    mySizedBox(),
                    mySizedBox(),
                    defaultButton(
                        onTap: () {
                          if (carOwnerName.length > 1) {
                            firebase
                                .customerAddRate(
                                    rate: rate.toString(),
                                    carOwnerName: carOwnerName)
                                .then((value) {
                              showSnackBar(
                                  context, "Your Rate submitted Successfully");
                            });
                            rate = 3;
                            setState(() {});
                          }
                        },
                        text: "Submit",
                        color: Colors.blue),
                  ],
                ),
              ));
            } else {
              return loadingWidget();
            }
          }),
    );
  }
}
