import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Trivio());
}

class Trivio extends StatelessWidget {
  const Trivio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Trivio",
      theme: ThemeData(
        primaryColor: const Color(0xFF003366),
        scaffoldBackgroundColor: const Color(0xFFF0F8F8),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF8FBC8F)),
      ),
      home: const SplashScreen(),
    );
  }
}
