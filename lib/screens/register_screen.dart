import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/models/Facade.dart';
import 'package:shared_ride_design_patterns/screens/login_screen.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const routeName = "RegisterPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String email, password, username;
  String? _carModel, _carPlateNumber, _typeOfCar, _carColor, _carIndustryYear;

  String userRole = "";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: isLoading
          ? loadingWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 80),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app_icon.png',
                      width: 150,
                      height: 150,
                    ),
                    const Text(
                      'Shared Ride',
                      style: TextStyle(
                        fontSize: 38,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    mySizedBox(),
                    defaultTextFormField(
                        onChanged: (String data) {
                          username = data;
                        },
                        hintText: 'Username'),
                    mySizedBox(),
                    defaultTextFormField(
                        onChanged: (String data) {
                          email = data;
                        },
                        hintText: 'Email'),
                    mySizedBox(),
                    defaultTextFormField(
                        onChanged: (String data) {
                          password = data;
                        },
                        hintText: 'Password'),
                    mySizedBox(),
                    defaultPopupMenu(
                      menuText: "Who Are you? ",
                      chosenValue: userRole,
                      menuIcon: Icons.person,
                      returnedBuilder: usersRole
                          .map(
                            (e) => PopupMenuItem(
                              value: e,
                              onTap: () {
                                userRole = e;
                                setState(() {});
                              },
                              child: Text(
                                e,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    mySizedBox(),
                    myConditionalBuilder(
                      condition: userRole == "Car Owner",
                      builder: Column(
                        children: [
                          defaultTextFormField(
                              onChanged: (String data) {
                                _carModel = data;
                              },
                              hintText: 'Car Model'),
                          mySizedBox(),
                          defaultTextFormField(
                              onChanged: (String data) {
                                _carPlateNumber = data;
                              },
                              hintText: 'Plate Number'),
                          mySizedBox(),
                          defaultTextFormField(
                              onChanged: (String data) {
                                _carIndustryYear = data;
                              },
                              hintText: 'Industry Year'),
                          mySizedBox(),
                          defaultPopupMenu(
                            menuText: "Car Type: ",
                            chosenValue: _typeOfCar ?? "",
                            menuIcon: Icons.car_repair,
                            returnedBuilder: ["Sedan", "Minivan", "Van"]
                                .map(
                                  (e) => PopupMenuItem(
                                    value: e,
                                    onTap: () {
                                      _typeOfCar = e;
                                      setState(() {});
                                    },
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          mySizedBox(),
                          defaultTextFormField(
                              onChanged: (String data) {
                                _carColor = data;
                              },
                              hintText: 'Color'),
                        ],
                      ),
                      fallback: const SizedBox(),
                    ),
                    mySizedBox(),
                    defaultButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});

                            await Facade.registerUser(
                              context: context,
                              userRole: userRole,
                              username: username,
                              email: email,
                              password: password,
                              carColor: _carColor,
                              carModel: _carModel,
                              typeOfCar: _typeOfCar,
                              carPlateNumber: _carPlateNumber,
                              carIndustryYear: _carIndustryYear,
                            );

                            isLoading = false;
                            setState(() {});
                          }
                        },
                        text: "Register"),
                    mySizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            navigateWithReplacement(
                              context: context,
                              routeName: LoginPage.routeName,
                            );
                          },
                          child: const Text(
                            ' Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
