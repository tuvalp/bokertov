import 'package:flutter/material.dart';

// Widgets
import '../widgets/alarm_view.dart';
import '../widgets/alarm_control.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                IconButton(
                  onPressed: () => (),
                  iconSize: 34,
                  icon: const Icon(Icons.person_rounded),
                  color: Colors.blue.shade300,
                ),
                IconButton(
                  onPressed: () => (),
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
