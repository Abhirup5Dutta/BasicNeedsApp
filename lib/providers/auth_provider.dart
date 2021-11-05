import 'package:basic_needs/providers/location_provider.dart';
import 'package:basic_needs/screens/homeScreen.dart';
import 'package:basic_needs/screens/landing_screen.dart';
import 'package:basic_needs/screens/main_screen.dart';
import 'package:basic_needs/screens/map_screen.dart';
import 'package:basic_needs/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp = '';
  String verificationId = '';
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String screen = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String address = '';
  String location;
  DocumentSnapshot snapshot;

  Future<void> verifyPhone(BuildContext context, String number) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      // if (e.code == 'invalid-phone-number') {
      //   print('The provided phone number is not valid.');
      // }
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int resendToken) async {
      this.verificationId = verId;

      // Open Dialog to enter received OTP SMS
      smsOtpDialog(context, number);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<dynamic> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 digit OTP received as SMS',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential phoneAuthcredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsOtp);

                    final User user =
                        (await _auth.signInWithCredential(phoneAuthcredential))
                            .user;

                    if (user != null) {
                      this.loading = false;
                      notifyListeners();

                      _userServices.getUserById(user.uid).then((snapShot) {
                        if (snapShot.exists) {
                          // user data already exists
                          if (this.screen == 'Login') {
                            // need to check user data already present in db or not
                            // if it is login, so no new data so we do not need to update
                            if (snapShot.data()['address'] != null) {
                              Navigator.pushReplacementNamed(
                                  context, MainScreen.id);
                            }
                            Navigator.pushReplacementNamed(
                                context, LandingScreen.id);
                          } else {
                            // need to update new selected address
                            updateUser(
                              id: user.uid,
                              number: user.phoneNumber,
                            );
                            Navigator.pushReplacementNamed(
                                context, MainScreen.id);
                          }
                        } else {
                          // user data does not exist
                          // will create new data in db
                          _createUser(id: user.uid, number: user.phoneNumber);
                          Navigator.pushReplacementNamed(
                              context, LandingScreen.id);
                        }
                      });
                    } else {
                      print('Login failed');
                    }

                    // Create user data in fireStore after user successfully registered

                  } catch (e) {
                    this.error = 'Invalid OTP';
                    notifyListeners();
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'DONE',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({String id, String number}) {
    _userServices.createUserData(
      {
        'id': id,
        'number': number,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address,
        'location': this.location,
      },
    );
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({String id, String number}) async {
    try {
      _userServices.updateUserData(
        {
          'id': id,
          'number': number,
          'latitude': this.latitude,
          'longitude': this.longitude,
          'address': this.address,
          'location': this.location,
        },
      );
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error ${e}');
      return false;
    }
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .get();
    if (result != null) {
      this.snapshot = result;
      notifyListeners();
    } else {
      this.snapshot = null;
      notifyListeners();
    }
    return result;
  }
}
