import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import '../services/account_box_item.dart';
import '../services/google_service.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final user = Hive.box<GoogleSignInAccountitem>("account").get("user");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Conant Dvices",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Connect new device",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ))
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    user == null
                        ? const Text(
                            "Conant Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            user!.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    TextButton(
                        onPressed: () {
                          user == null
                              ? GoogleService().handleSignIn()
                              : GoogleService().handelSignOut();
                        },
                        child: Text(
                          user == null ? "Sign in" : "Sign out",
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 16),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
