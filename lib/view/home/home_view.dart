import 'package:flutter/material.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/logout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            defaultTextButton(
                function: () {
                  logOut(context);
                },
                text: 'logOut',
                context: context)
          ],
        ),
      ),
    );
  }
}
