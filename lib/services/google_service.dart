import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import '../services/account_box_item.dart';

class GoogleService {
  final accountBox = Hive.box<GoogleSignInAccountitem>('account');
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

  void handelSignOut() {
    _googleSignIn!.disconnect();
    accountBox.delete(const Key('user'));
  }

  Future<void> handleSignIn() async {
    try {
      if (accountBox.get('user') == null) {
        _currentUser = await _googleSignIn!.signIn();
        accountBox.put(
            'user',
            GoogleSignInAccountitem(
              displayName: _currentUser!.displayName!,
              email: _currentUser!.email,
              id: _currentUser!.id,
              photoUrl: _currentUser!.photoUrl,
            ));
        print('Signed in as ${_currentUser!.displayName}');
      } else {
        _currentUser = _googleSignIn!.currentUser;
      }
      print(accountBox.get('user'));
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

  void singOption() {
    _googleSignIn!.signIn();
  }

  Future<void> fetchData() async {
    try {
      if (_currentUser == null) {
        print('User not signed in.');
        return;
      }

      GoogleSignInAccount account = _googleSignIn!.currentUser!;
      GoogleSignInAuthentication _auth = await account.authentication;
      final client = await auth.clientViaUserConsent(
        ClientId(
          'YOUR_CLIENT_ID',
          'YOUR_CLIENT_SECRET',
        ),
        scopes,
        promptUser: true,
      );

      final fitnessApi = fitness.FitnessApi(client);

      // Use fitnessApi to make requests and fetch data
      // Example: List the user's data sources
      var dataSources = await fitnessApi.users.dataSources.list('me');
      print(dataSources);
    } catch (error) {
      print('Fetch Data Error: $error');
    }
  }
}
