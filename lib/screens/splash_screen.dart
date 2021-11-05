import 'dart:async';
import 'package:basic_needs/screens/homeScreen.dart';
import 'package:basic_needs/screens/landing_screen.dart';
import 'package:basic_needs/screens/main_screen.dart';
import 'package:basic_needs/screens/welcome_screen.dart';
import 'package:basic_needs/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        } else {
          // Navigator.pushReplacementNamed(context, LandingScreen.id);
          getUserData();
        }
      });
    });

    super.initState();
  }

  getUserData() async {
    UserServices _userServices = UserServices();

    _userServices.getUserById(user.uid).then((result) {
      // Check location details present or not
      if (result.data()['address'] != null) {
        // If address details exists
        updatePrefs(result);
      }
      // If address details do not exist
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void> updatePrefs(result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);
    // After updatePrefs, we navigate to homescreen
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/logo.png'),
            Text(
              'Basic Needs App',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }
}
