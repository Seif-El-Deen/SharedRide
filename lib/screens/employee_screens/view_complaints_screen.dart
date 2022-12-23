import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/models/complain.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class ViewCustomerComplaints extends StatefulWidget {
  const ViewCustomerComplaints({Key? key}) : super(key: key);

  @override
  State<ViewCustomerComplaints> createState() => _ViewCustomerComplaintsState();
}

class _ViewCustomerComplaintsState extends State<ViewCustomerComplaints> {
  FirebaseDatabase firebase = FirebaseDatabase.getInstance();

  List<Complaint> complaints = [];
  Map<String, int> carOwnerNumOfComplaints = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(),
      drawer: carOwnerDrawer(context: context),
      body: StreamBuilder(
          stream: firebase.fireStore.collection('Complaints').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              complaints = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                dynamic data = snapshot.data!.docs[i].data();

                complaints.add(
                  Complaint(
                    snapshot.data!.docs[i].id,
                    data['customerName'],
                    data['carOwnerName'],
                    data['complaint'],
                  ),
                );
                // carOwnerNames.add(data['carOwnerName']);
              }

              complaints.forEach((element) {
                if (!carOwnerNumOfComplaints
                    .containsKey(element.carOwnerName)) {
                  carOwnerNumOfComplaints[element.carOwnerName] = 1;
                } else {
                  carOwnerNumOfComplaints[element.carOwnerName] =
                      1 + carOwnerNumOfComplaints[element.carOwnerName]!;
                }
              });

              return SafeArea(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                // width: 200,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Column(children: [
                        Text(
                          "Customer Name: ${complaints[index].customerName}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Car Owner Name: ${complaints[index].carOwnerName}",
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Complaint: \n${complaints[index].complain}",
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Number of complaints made on this Car Owner: ${carOwnerNumOfComplaints[complaints[index].carOwnerName]}",
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        myConditionalBuilder(
                          condition: (carOwnerNumOfComplaints[
                                  complaints[index].carOwnerName])! >=
                              10,
                          builder: defaultButton(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StreamBuilder(
                                      stream: firebase.fireStore
                                          .collection('carOwners')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          for (int i = 0;
                                              i < snapshot.data!.docs.length;
                                              i++) {
                                            dynamic data =
                                                snapshot.data!.docs[i].data();
                                            if (data['username'] ==
                                                complaints[index]
                                                    .carOwnerName) {
                                              Navigator.pop(context);
                                            }
                                          }

                                          return loadingWidget();
                                        }
                                        return loadingWidget();
                                      });
                                },
                              );
                            },
                            text: "Remove User",
                            color: Colors.red,
                          ),
                          fallback: const SizedBox(),
                        ),
                      ]);
                    },
                    separatorBuilder: (context, index) {
                      return myDivider();
                    },
                    itemCount: complaints.length),
              ));
            } else {
              return loadingWidget();
            }
          }),
    );
  }
}
