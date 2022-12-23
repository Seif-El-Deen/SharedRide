import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/database/firebase.dart';
import 'package:shared_ride_design_patterns/screens/customer_screens/complaint_driver_screen.dart';
import 'package:shared_ride_design_patterns/screens/customer_screens/rate_driver_screen.dart';
import 'package:shared_ride_design_patterns/screens/login_screen.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';

Widget loadingWidget() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget defaultTextFormField(
    {required Function(String)? onChanged,
    required String hintText,
    int maxLines = 1}) {
  return TextFormField(
    validator: (data) {
      if (data!.isEmpty) {
        return 'Field is required';
      }
      return null;
    },
    onChanged: onChanged,
    obscureText: hintText == 'Password',
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget defaultButton(
    {required VoidCallback onTap,
    required String text,
    Color color = Colors.white,
    Color textColor = Colors.black,
    double width = double.infinity}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w400, color: textColor),
      ),
    ),
  );
}

Widget profileEditableText(
    {required BuildContext context,
    required String label,
    isObscure = false,
    void Function()? onTap,
    required String text}) {
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.blue),
        ),
      ),
      const SizedBox(height: 3),
      Stack(
        children: [
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    !isObscure ? text : '${text.replaceAll(RegExp(r"."), "*")}',
                    maxLines: 2,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )
                  // Text(
                  //   text,
                  //   maxLines: 2,
                  //   style: const TextStyle(fontSize: 20),
                  //   textAlign: TextAlign.center,
                  // ),
                  ),
            ],
          ),
          Positioned(
            top: 12,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget myDivider(
    {double thickness = 1, double height = 10, Color color = Colors.grey}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Divider(
      color: color,
      height: height,
      thickness: thickness,
    ),
  );
}

Widget mySizedBox() {
  return const SizedBox(height: 20);
}

Widget customerDrawer({required BuildContext context}) {
  return Drawer(
    width: MediaQuery.of(context).size.width * 0.6,
    backgroundColor: Colors.grey[800],
    child: SafeArea(
      child: Column(
        children: [
          Container(
            color: primaryColor,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/app_icon.png",
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Shared Ride",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 15.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RateDriverScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/rate.png",
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Rate a Driver",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  myDivider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComplainDriverScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/complaints.png",
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Complaints",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.grey,
                      height: 10,
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/info.png",
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "About Us",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.grey,
                      height: 10,
                      thickness: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseDatabase firebase =
                          FirebaseDatabase.getInstance();
                      firebase.logoutUser(context: context).then((value) {
                        currentCustomer = null;
                        currentEmployee = null;
                        navigateWithReplacement(
                            context: context, routeName: LoginPage.routeName);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/logout.png",
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Logout",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget carOwnerDrawer({required BuildContext context}) {
  return Drawer(
    width: MediaQuery.of(context).size.width * 0.6,
    backgroundColor: Colors.grey[800],
    child: SafeArea(
      child: Column(
        children: [
          Container(
            color: primaryColor,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/app_icon.png",
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Shared Ride",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/info.png",
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "About Us",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.grey,
                      height: 10,
                      thickness: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseDatabase firebase =
                          FirebaseDatabase.getInstance();
                      firebase.logoutUser(context: context).then(
                        (value) {
                          currentCarOwner = null;
                          navigateWithReplacement(
                            context: context,
                            routeName: LoginPage.routeName,
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/logout.png",
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Logout",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget defaultPopupMenu(
    {String chosenValue = "",
    required List<PopupMenuEntry<dynamic>> returnedBuilder,
    required String menuText,
    required IconData menuIcon}) {
  return PopupMenuButton(
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      // height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            menuIcon,
            size: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            menuText + chosenValue,
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    ),
    itemBuilder: (BuildContext context) {
      return returnedBuilder;
    },
  );
}

Widget bottomNavigationBar(
    {required BuildContext context, required int selectedIndex}) {
  return BottomNavigationBar(
    selectedLabelStyle: const TextStyle(fontSize: 18),
    unselectedLabelStyle: const TextStyle(
      fontSize: 18,
    ),
    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    backgroundColor: Colors.white,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/profile.png",
          width: 34,
          height: 34,
        ),
        label: 'Profile',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/booking.png",
          width: 34,
          height: 34,
        ),
        label: 'Book',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/history.png",
          width: 34,
          height: 34,
        ),
        label: ' History',
      ),
    ],
    currentIndex: selectedIndex,
    selectedItemColor: Colors.amber[800],
    unselectedItemColor: Colors.black,
    showUnselectedLabels: true,
    onTap: (val) {
      customerBottomNavigationBarNavigation(context: context, index: val);
    },
  );
}

Widget carOwnerBottomNavigationBar(
    {required BuildContext context, required int selectedIndex}) {
  return BottomNavigationBar(
    selectedLabelStyle: const TextStyle(fontSize: 18),
    unselectedLabelStyle: const TextStyle(
      fontSize: 18,
    ),
    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    backgroundColor: Colors.white,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/search.png",
          width: 34,
          height: 34,
        ),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/add_trip.png",
          width: 34,
          height: 34,
        ),
        label: 'Add Trip',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/history.png",
          width: 34,
          height: 34,
        ),
        label: ' History',
      ),
    ],
    currentIndex: selectedIndex,
    selectedItemColor: Colors.amber[800],
    unselectedItemColor: Colors.black,
    showUnselectedLabels: true,
    onTap: (val) {
      carOwnerBottomNavigationBarNavigation(context: context, index: val);
    },
  );
}
