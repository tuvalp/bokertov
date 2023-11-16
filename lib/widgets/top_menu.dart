import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: () => (), icon: const Icon(Icons.account_circle)),
        IconButton(onPressed: () => (), icon: const Icon(Icons.settings)),
      ],
    );
  }
}
