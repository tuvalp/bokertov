import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';


class GoogleService {
  final accountBox = Hive.box('account');
  final List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/fitness.blood_pressure.read',
    'https://www.googleapis.com/auth/fitness.blood_glucose.read',
    'https://www.googleapis.com/auth/fitness.heart_rate.read',
  ];

  GoogleSignIn? _googleSignIn;
  GoogleSignInAccount? _currentUser;

  GoogleService() {
    _googleSignIn = GoogleSignIn(
      scopes: scopes,
    );
  }

  Future<void> handleSignIn() async {
    try {
      if(accountBox.get('user') == null) {
         _currentUser = await _googleSignIn!.signIn();
         accountBox.put('user', _currentUser);
         print('Signed in as ${_currentUser!.displayName}');
      } else {
        _currentUser = _googleSignIn!.currentUser;
        if (_currentUser == null) {
          _currentUser = await _googleSignIn!.signInSilently();
        }
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

}
