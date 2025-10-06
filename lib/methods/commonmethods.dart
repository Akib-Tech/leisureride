import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:leisureride/driver/driver_dashboard.dart';
import 'package:leisureride/userspage/home.dart';
import 'package:leisureride/userspage/login.dart';
import 'package:leisureride/userspage/profile.dart';
import '../widgets/loadingDialog.dart';

class CommonMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase dBase = FirebaseDatabase.instance;
  late final DatabaseReference rideRequestRef = dBase.ref("rideRequests");

  /// ✅ Check internet connectivity
  Future<bool> checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    return (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
  }

  /// ✅ Show snackbar message
  void displaySnackBar(String messageText, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          messageText,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// ✅ Show loading dialog
  void loadDialog(String message, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LoadingDialog(messageText: message),
    );
  }

  /// ✅ Register new users
  Future<void> registerNewUsers(
      String email,
      String firstname,
      String lastname,
      String username,
      String password,
      String phone,
      BuildContext context,
      ) async {
    loadDialog("Registering user...", context);
    try {
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      Navigator.pop(context); // Close loading dialog

      if (firebaseUser != null) {
        DatabaseReference usersRef = dBase.ref().child("users").child(firebaseUser.uid);

        Map<String, dynamic> userData = {
          "id": firebaseUser.uid,
          "email": email.trim(),
          "firstname": firstname.trim(),
          "lastname": lastname.trim(),
          "username": username.trim(),
          "phone": phone.trim(),
          "createdAt": DateTime.now().toIso8601String(),
          "blockStatus": "no",
        };

        await usersRef.set(userData);

        displaySnackBar("Account created successfully!", context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        displaySnackBar("Account creation failed.", context);
      }
    } catch (error) {
      Navigator.pop(context);
      displaySnackBar(error.toString(), context);
    }
  }

  /// ✅ Login user
  Future<void> loginUser(String email, String password, BuildContext context) async {
    loadDialog("Verifying user...", context);
    try {
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      Navigator.pop(context); // Close loading dialog

      if (firebaseUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        displaySnackBar("Incorrect login details.", context);
      }
    } catch (error) {
      Navigator.pop(context);
      displaySnackBar(error.toString(), context);
    }
  }

  /// ✅ Fetch user data from Firebase
  Future<Map<String, dynamic>?> fetchingData() async {
    final user = auth.currentUser;
    if (user == null) return null;

    final event = await dBase.ref().child("users").child(user.uid).once();
    if (event.snapshot.value != null) {
      return Map<String, dynamic>.from(event.snapshot.value as Map);
    }
    return null;
  }

  /// ✅ Update user profile
  Future<void> updateProfile(
      String email,
      String firstname,
      String lastname,
      String username,
      String phone,
      BuildContext context,
      ) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        DatabaseReference userRef = dBase.ref().child("users").child(user.uid);
        Map<String, dynamic> updateData = {
          "email": email.trim(),
          "firstname": firstname.trim(),
          "lastname": lastname.trim(),
          "username": username.trim(),
          "phone": phone.trim(),
        };

        await userRef.update(updateData);

        displaySnackBar("Profile successfully updated.", context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
      } else {
        displaySnackBar("User not logged in.", context);
      }
    } catch (e) {
      displaySnackBar(e.toString(), context);
    }
  }

  /// ✅ Register new driver
  Future<void> registerNewDriver(
      String email,
      String firstname,
      String lastname,
      String username,
      String password,
      String phone,
      BuildContext context,
      ) async {
    loadDialog("Registering driver...", context);
    try {
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      Navigator.pop(context); // Close loading dialog

      if (firebaseUser != null) {
        DatabaseReference driverRef = dBase.ref().child("drivers").child(firebaseUser.uid);

        Map<String, dynamic> driverData = {
          "id": firebaseUser.uid,
          "email": email.trim(),
          "firstname": firstname.trim(),
          "lastname": lastname.trim(),
          "username": username.trim(),
          "phone": phone.trim(),
          "createdAt": DateTime.now().toIso8601String(),
          "blockStatus": "no",
        };

        await driverRef.set(driverData);

        displaySnackBar("Driver account created successfully!", context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DriverDashboard()),
        );
      } else {
        displaySnackBar("Driver account creation failed.", context);
      }
    } catch (error) {
      Navigator.pop(context);
      displaySnackBar(error.toString(), context);
    }
  }

  /// ✅ Login driver
  Future<void> loginDriver(String email, String password, BuildContext context) async {
    loadDialog("Verifying driver...", context);
    try {
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      Navigator.pop(context);

      if (firebaseUser != null) {
        DatabaseReference driverRef = dBase.ref().child("drivers").child(firebaseUser.uid);
        DatabaseEvent event = await driverRef.once();

        if (event.snapshot.value != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DriverDashboard()),
          );
        } else {
          await auth.signOut();
          displaySnackBar("No driver account found for this email.", context);
        }
      } else {
        displaySnackBar("Incorrect login details.", context);
      }
    } catch (error) {
      Navigator.pop(context);
      displaySnackBar(error.toString(), context);
    }
  }

  /// ✅ Create a new ride request
  Future<void> findRider(
      double pickupLat,
      double pickupLng,
      double destLat,
      double destLng,
      ) async {
    User? user = auth.currentUser;
    if (user == null) return;

    String requestId = DateTime.now().microsecondsSinceEpoch.toString();

    Map<String, dynamic> rideData = {
      "request_id": requestId,
      "passenger_id": user.uid,
      "pickup": {"lat": pickupLat, "lng": pickupLng},
      "destination": {"lat": destLat, "lng": destLng},
      "status": "pending",
    };

    await rideRequestRef.child(requestId).set(rideData);
    debugPrint("✅ Ride request created successfully");
  }

  /// ✅ Notify driver in real-time
  void driverRideNotice(BuildContext context) {
    rideRequestRef.onChildAdded.listen((event) {
      final rideData = Map<String, dynamic>.from(event.snapshot.value as Map);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("New Ride Request"),
          content: Text(
            "Pickup: ${rideData['pickup']}\nDestination: ${rideData['destination']}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    });
  }
}
