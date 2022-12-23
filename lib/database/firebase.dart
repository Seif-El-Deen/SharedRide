import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_ride_design_patterns/models/car.dart';
import 'package:shared_ride_design_patterns/models/customer.dart';
import 'package:shared_ride_design_patterns/models/trip.dart';
import 'package:shared_ride_design_patterns/models/person.dart';
import 'package:shared_ride_design_patterns/shared/constants.dart';
import 'package:shared_ride_design_patterns/shared/shared_functions.dart';

class FirebaseDatabase {
  late FirebaseAuth _auth;
  late FirebaseFirestore _fireStore;
  static FirebaseDatabase? _firebaseDatabase;
  // static int counter = 0;
  FirebaseDatabase._() {
    _auth = FirebaseAuth.instance;
    _fireStore = FirebaseFirestore.instance;
    // counter++;
  }
  static FirebaseDatabase getInstance() {
    // if(_firebaseDatabase==null){
    //   _firebaseDatabase= FirebaseDatabase._();
    // }
    // Lazy Initialization
    _firebaseDatabase ??= FirebaseDatabase._();
    // print("number of firebase instances $counter");

    return _firebaseDatabase!;
  }

  Future<void> carOwnerAddTrip({
    required String pickupPoint,
    required String destination,
    required String tripTime,
  }) async {
    CollectionReference trip = _fireStore.collection('Trips');
    trip
        .add({
          "carOwnerName": currentCarOwner!.userName,
          "carModel": currentCarOwner!.car.model,
          "customerName": "notAdded",
          "pickupPoint": pickupPoint,
          'destination': destination,
          "tripTime": tripTime,
        })
        .then((value) {})
        .catchError((error) {
          print(error);
        });
  }

  Future<void> customerAddComplain(
      {required String carOwnerName, required String complaint}) async {
    CollectionReference trip = _fireStore.collection('Complaints');
    trip
        .add({
          "customerName": currentCustomer!.userName,
          "carOwnerName": carOwnerName,
          "complaint": complaint,
        })
        .then((value) {})
        .catchError((error) {
          print(error);
        });
  }

  Future<void> moveTripToTripHistory({
    required Trip trip,
    required String rowId,
  }) async {
    CollectionReference tripsTable = _fireStore.collection('Trips');
    tripsTable.doc(rowId).delete();
    CollectionReference tripsHistoryTable =
        _fireStore.collection('TripsHistory');

    tripsHistoryTable
        .add({
          "carOwnerName": trip.carOwnerName,
          "carModel": trip.carModel,
          "customerName": trip.customerName,
          "pickupPoint": trip.pickupPoint,
          'destination': trip.destination,
          "tripTime": trip.tripTime,
        })
        .then((value) {})
        .catchError((error) {
          print(error);
        });
  }

  Future<void> customerAddRate({
    required String carOwnerName,
    required String rate,
  }) async {
    CollectionReference rateTable = _fireStore.collection('Rates');
    rateTable
        .add({
          "customerName": currentCustomer!.userName,
          "carOwnerName": carOwnerName,
          "rate": rate,
        })
        .then((value) {})
        .catchError((error) {
          print(error);
        });
  }

  Future<void> customerAddComplaint({
    required String carOwnerName,
    required String complaint,
  }) async {
    CollectionReference complaintsTable = _fireStore.collection('Complaints');
    complaintsTable
        .add({
          "customerName": currentCustomer!.userName,
          "carOwnerName": carOwnerName,
          "complaint": complaint,
        })
        .then((value) {})
        .catchError((error) {
          print(error);
        });
  }

  Future<void> loginUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<bool> logoutUser({
    required BuildContext context,
  }) async {
    await _auth.signOut().then((value) {
      return true;
    }).catchError((error) {
      showSnackBar(context, error.toString());
      return false;
    });
    return false;
  }

  Future<bool> registerUser(
      {required BuildContext context,
      required String userType,
      required Person user,
      Car? car}) async {
    await _auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((value) async {
      await userSetup(person: user, userType: userType, car: car).then((value) {
        return true;
      }).catchError((error) {
        showSnackBar(context, error.toString());
        return false;
      });
    }).catchError((error) {
      showSnackBar(context, error.toString());
      // return false;
    });

    return false;
  }

  Future<void> deleteCustomerAccount({required String customerId}) async {
    _auth.currentUser!.delete();
    CollectionReference carOwner = _fireStore.collection('Customers');
    carOwner.doc(customerId).delete();
  }

  Future<void> deleteCarOwnerAccount({required String carOwnerId}) async {
    CollectionReference customer = _fireStore.collection('carOwners');
    customer.doc(carOwnerId).delete();
  }

  Future<void> updateCustomerProfile({required String customerId}) async {
    CollectionReference customer = _fireStore.collection('Customers');
    _auth.currentUser!.updateEmail(currentCustomer!.email);
    _auth.currentUser!.updatePassword(currentCustomer!.password);

    customer.doc(customerId).update({
      "email": currentCustomer!.email,
      "password": currentCustomer!.password,
      "username": currentCustomer!.userName,
    });
  }

  Future<void> updateTripCustomer(
      {required String tripId,
      required String rowId,
      required String customerName}) async {
    CollectionReference customer = _fireStore.collection('Trips');
    customer.doc(tripId).update({
      "customerName": customerName,
    });
  }

  Future<void> userSetup(
      {required String? userType, required Person person, Car? car}) async {
    try {
      CollectionReference user;
      switch (userType) {
        case "Customer":
          user = _fireStore.collection('Customers');
          user.add({
            "username": person.userName,
            "email": person.email,
            'password': person.password,
          });
          break;
        case "Car Owner":
          user = _fireStore.collection('carOwners');
          // CarOwner carOwner = person as CarOwner;
          user.add({
            "username": person.userName,
            "email": person.email,
            'password': person.password,
            "carModel": car!.model,
            "carPlateNumber": car.plateNumber,
            "carType": car.type.type,
            "carColor": car.color,
            "carIndustryYear": car.industryYear,
          });
          break;
        case "Employee":
          user = _fireStore.collection('Employees');
          user.add({
            "username": person.userName,
            "email": person.email,
            'password': person.password,
          });
          break;
      }
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<void> customerAskedForRide(
      {required String carOwnerName, required String tripId}) async {
    try {
      CollectionReference askedOwnerTable =
          _fireStore.collection('AskedForRide');

      askedOwnerTable.add({
        "customerName": currentCustomer!.userName,
        "carOwnerName": carOwnerName,
        "tripId": tripId,
      });
    } catch (e) {}
  }

  Future<void> deleteAskedForRideRow({required String rowId}) async {
    CollectionReference row = _fireStore.collection('AskedForRide');
    await row.doc(rowId).delete();
  }

  Future<Customer> getCustomerData({required String customerId}) async {
    var collection = _fireStore.collection('Customers');
    var docSnapshot = await collection.doc(customerId).get();
    Map<String, dynamic>? data = docSnapshot.data();
    print(data!['email']);
    print(data['password']);
    print(data['username']);
    return Customer(
        id: customerId,
        userName: data['username'],
        email: data['email'],
        password: data['password'],
        age: "");
  }

  FirebaseFirestore get fireStore => _fireStore;
}
