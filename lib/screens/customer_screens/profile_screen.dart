import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/models/customer.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "ProfilePage";

  const ProfileScreen({required this.customer});

  final Customer customer;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String newUsername = "";
  String newEmail = "";
  String newPassword = "";
  // String newAge = "";
  FirebaseDatabase firebase = FirebaseDatabase.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(),
      drawer: customerDrawer(context: context),
      body: StreamBuilder<QuerySnapshot>(
          stream: firebase.fireStore.collection("Customers").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                dynamic data = snapshot.data!.docs[i].data();
                if (data["email"] == widget.customer.email &&
                    data["password"] == widget.customer.password) {
                  currentCustomer = Customer(
                          id: snapshot.data!.docs[i].id,
                          userName: data["username"],
                          email: data["email"],
                          password: data["password"],
                          age: "age")
                      .getClone() as Customer?;
                }
              }
              return SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: ListView(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          child: Image.asset(
                            "assets/images/profile.png",
                            width: 250,
                            height: 250,
                          ),
                        ),
                        mySizedBox(),
                        profileEditableText(
                          context: context,
                          label: "Username",
                          text: currentCustomer!.userName,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(0),
                                  content: Container(
                                    padding: const EdgeInsets.all(15),
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.9,
                                    height: 250,
                                    color: Colors.grey,
                                    child: defaultTextFormField(
                                        onChanged: (value) {
                                          newUsername = value;
                                          setState(() {});
                                        },
                                        hintText: "New username"),
                                  ),
                                  actions: [
                                    defaultButton(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Cancel",
                                    ),
                                    myDivider(),
                                    defaultButton(
                                      onTap: () async {
                                        currentCustomer!.userName = newUsername;
                                        setState(() {});
                                        await firebase
                                            .updateCustomerProfile(
                                                customerId: currentCustomer!.id)
                                            .then((value) {
                                          showSnackBar(context,
                                              "Username Updated Successfully",
                                              color: Colors.green);
                                          Navigator.pop(context);
                                        });
                                      },
                                      text: "Update",
                                    )
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                        mySizedBox(),
                        profileEditableText(
                          context: context,
                          label: "Email",
                          text: currentCustomer!.email,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(0),
                                  content: Container(
                                    padding: const EdgeInsets.all(15),
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.9,
                                    height: 250,
                                    color: Colors.grey,
                                    child: defaultTextFormField(
                                        onChanged: (value) {
                                          newEmail = value;
                                          setState(() {});
                                        },
                                        hintText: "New Email"),
                                  ),
                                  actions: [
                                    defaultButton(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Cancel",
                                    ),
                                    myDivider(),
                                    defaultButton(
                                      onTap: () async {
                                        // await firebase.deleteCustomerAccount(
                                        //     customerId: currentCustomer!.id);
                                        // currentCustomer!.email = newEmail;
                                        // await firebase.registerUser(
                                        //     context: context,
                                        //     userType: "Customer",
                                        //     user: currentCustomer!);
                                        firebase.updateCustomerProfile(
                                            customerId: currentCustomer!.id);
                                        setState(() {});
                                        showSnackBar(context,
                                            "Email Updated Successfully",
                                            color: Colors.green);
                                        Navigator.pop(context);
                                      },
                                      text: "Update",
                                    )
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                        mySizedBox(),
                        profileEditableText(
                          context: context,
                          label: "Password",
                          isObscure: true,
                          text: currentCustomer!.password,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(0),
                                  content: Container(
                                    padding: const EdgeInsets.all(15),
                                    height: 250,
                                    color: Colors.grey,
                                    child: defaultTextFormField(
                                        onChanged: (value) {
                                          newPassword = value;
                                          setState(() {});
                                        },
                                        hintText: "New Password"),
                                  ),
                                  actions: [
                                    defaultButton(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Cancel",
                                    ),
                                    myDivider(),
                                    defaultButton(
                                      onTap: () async {
                                        await firebase.deleteCustomerAccount(
                                            customerId: currentCustomer!.id);
                                        currentCustomer!.password = newPassword;
                                        await firebase.registerUser(
                                            context: context,
                                            userType: "Customer",
                                            user: currentCustomer!);
                                        setState(() {});
                                        showSnackBar(context,
                                            "Password Updated Successfully",
                                            color: Colors.green);
                                        Navigator.pop(context);
                                      },
                                      text: "Update",
                                    )
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return loadingWidget();
            }
          }),
      bottomNavigationBar: bottomNavigationBar(
        context: context,
        selectedIndex: 0,
      ),
    );
  }
}
