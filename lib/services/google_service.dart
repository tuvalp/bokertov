import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  final List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/fitness.blood_pressure.read',
    'https://www.googleapis.com/auth/fitness.blood_glucose.read',
    'https://www.googleapis.com/auth/fitness.heart_rate.read',
  ];

  GoogleSignIn? _googleSignIn;

  GoogleService() {
    _googleSignIn = GoogleSignIn(
      scopes: scopes,
    );
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn!.signIn(); // Note the non-null assertion operator here
    } catch (error) {
      // Handle specific errors or log for debugging
      print('Google Sign-In Error: $error');
    }
  }
}
