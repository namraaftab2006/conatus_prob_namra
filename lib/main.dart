import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Factify());
}


class Factify extends StatelessWidget {
  const Factify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SignupPage(),

    );
  }
}