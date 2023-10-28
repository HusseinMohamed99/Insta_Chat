import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_chat/firebase_options.dart';
import 'package:insta_chat/utils/themes.dart';
import 'package:insta_chat/view/signIn/sign_in_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insta Chat',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SignInView(),
    );
  }
}
