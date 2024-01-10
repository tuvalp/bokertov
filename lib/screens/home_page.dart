import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Widgets
import '../widgets/alarm_view.dart';
import '../widgets/alarm_control.dart';

// Services
import '../services/account_box_item.dart';
import '../services/google_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = Hive.box<GoogleSignInAccountitem>("account").get("user");

  FloatingActionButton addAlarmButton(context) => FloatingActionButton(
        onPressed: (() {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            isDismissible: false,
            showDragHandle: false,
            context: context,
            builder: (context) => const ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
              child: AlarmContorl(),
            ),
          );
        }),
        child: const Icon(Icons.alarm_add),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: const AlarmView(),
        floatingActionButton: addAlarmButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 60.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                user == null
                    ? IconButton(
                        onPressed: () => GoogleService().handleSignIn(),
                        iconSize: 34,
                        icon: const Icon(Icons.person_rounded),
                        color: Colors.blue.shade300,
                      )
                    : user!.photoUrl == null
                        ? TextButton(
                            onPressed: () => GoogleService().handelSignOut(),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                color: Colors.blue.shade300,
                              ),
                              child: Center(
                                child: Text(
                                  user!.displayName[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Image.network(user!.photoUrl!,
                                  width: 34, height: 34),
                            ),
                            onTap: () => GoogleService().singOption(),
                          ),
                IconButton(
                  onPressed: () =>
                      (Navigator.of(context).pushNamed("/settings")),
                  iconSize: 34,
                  icon: const Icon(Icons.settings),
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
