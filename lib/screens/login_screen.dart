import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/models/Facade.dart';
import 'package:shared_ride_design_patterns/screens/register_screen.dart';
import 'package:shared_ride_design_patterns/shared/colors.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';
import 'package:shared_ride_design_patterns/shared/shared_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email, password;
  String userType = "";
  // bool checkBoxValue = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: myConditionalBuilder(
        condition: isLoading,
        builder: loadingWidget(),
        fallback: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 130),
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
                    // fontFamily: "VarelaRound-Regular",
                  ),
                ),
                // const Spacer(flex: 2),
                Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      // fontFamily: 'pacifico',
                    ),
                  ),
                ),
                mySizedBox(),
                defaultTextFormField(
                    onChanged: (String? data) {
                      email = data;
                    },
                    hintText: 'Email'),
                mySizedBox(),
                defaultTextFormField(
                    onChanged: (String? data) {
                      password = data;
                    },
                    hintText: 'Password'),
                mySizedBox(),
                defaultPopupMenu(
                  menuText: "Who Are you? ",
                  chosenValue: userType,
                  menuIcon: Icons.person,
                  returnedBuilder: usersRole
                      .map(
                        (e) => PopupMenuItem(
                          value: e,
                          onTap: () {
                            userType = e;
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
                // const SizedBox(height: 20),
                // SizedBox(
                //   width: double.infinity,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       CircleAvatar(
                //         backgroundColor: Colors.white,
                //         child: Checkbox(
                //             value: checkBoxValue,
                //             onChanged: (bool? value) {
                //               checkBoxValue = value ?? false;
                //               setState(() {});
                //             }),
                //       ),
                //       const SizedBox(
                //         width: 8,
                //       ),
                //       const Text(
                //         "Keep my login?",
                //         style: TextStyle(fontSize: 18, color: Colors.white),
                //       )
                //     ],
                //   ),
                // ),
                mySizedBox(),
                defaultButton(
                    onTap: () async {
                      if (formKey.currentState!.validate() &&
                          usersRole.contains(userType)) {
                        isLoading = true;
                        setState(() {});
                        await Facade.loginUser(
                            context: context,
                            email: email!,
                            password: password!,
                            userType: userType);
                        isLoading = false;
                        setState(() {});
                      }
                    },
                    text: "Login"),
                mySizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigateWithReplacement(
                            context: context,
                            routeName: RegisterPage.routeName);
                      },
                      child: const Text(
                        ' Register',
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
      ),
    );
  }
}
