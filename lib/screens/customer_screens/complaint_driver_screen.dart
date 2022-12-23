import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class ComplainDriverScreen extends StatefulWidget {
  const ComplainDriverScreen({Key? key}) : super(key: key);

  @override
  State<ComplainDriverScreen> createState() => _ComplainDriverScreenState();
}

class _ComplainDriverScreenState extends State<ComplainDriverScreen> {
  FirebaseDatabase firebase = FirebaseDatabase.getInstance();

  List<String> carOwners = [];
  String carOwnerName = "";
  String complaint = "";

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
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                // width: 200,
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
                              style: const TextStyle(fontSize: 20),
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
                    defaultTextFormField(
                      onChanged: (value) {
                        complaint = value;
                      },
                      hintText: "Write your complain.",
                      maxLines: 4,
                    ),
                    mySizedBox(),
                    mySizedBox(),
                    defaultButton(
                      onTap: () {
                        if (complaint.isNotEmpty && carOwnerName.length > 1) {
                          firebase
                              .customerAddComplain(
                                  complaint: complaint,
                                  carOwnerName: carOwnerName)
                              .then((value) {
                            showSnackBar(context,
                                "Your Complaint submitted Successfully");
                          });
                        }
                      },
                      text: "Submit",
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
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
