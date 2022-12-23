import 'dart:core';

abstract class Person {
  late String _id;
  late String _userName;
  late String _email;
  late String _password;
  String? _age;

  Person(
      {required String id,
      required String userName,
      required String email,
      required String password,
      required String age}) {
    _id = id;
    _userName = userName;
    _email = email;
    _password = password;
    _age = age;
  }

  // Person.emptyPerson() {
  //   _id = "id";
  //   _userName = "userName";
  //   _email = "email";
  //   _password = "password";
  //   _age = "age";
  // }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get age => _age!;

  set age(String value) {
    _age = value;
  }

// bool validateEmail(String email) {
//   String regex = "^(?=.{1,64}@)[A-Za-z0-9_-]+(\\.[A-Za-z0-9_-]+)*@" +
//       "[^-][A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})";
//
//   return false;
//   // Pattern pattern = Pattern.compile(regex);
//   // Matcher matcher = pattern.matcher(email);
//   // if(matcher.matches() == false){
//   //   System.out.println("Invalid Email!");
//   //   return false;
//   // }
//   // System.out.println("Valid Email");
//   // return true;
//   //Function Explanation
//   /*The following restrictions are imposed in the email address' local part by using this regex:
//       It allows numeric values from 0 to 9.
//       Both uppercase and lowercase letters from a to z are allowed.
//       Allowed are underscore “_”, hyphen “-“, and dot “.”
//       Dot isn't allowed at the start and end of the local part.
//       Consecutive dots aren't allowed.
//       For the local part, a maximum of 64 characters are allowed.
//       Restrictions for the domain part in this regular expression include:
//       It allows numeric values from 0 to 9.
//       We allow both uppercase and lowercase letters from a to z.
//       Hyphen “-” and dot “.” aren't allowed at the start and end of the domain part.
//       No consecutive dots.
//       user.name@domain.com --> Valid
//       .user.name@domain.com --> InValid
//       */
// }
}
