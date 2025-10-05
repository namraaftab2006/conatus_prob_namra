import 'package:flutter/material.dart';
import 'create_account_page.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F8),
      appBar: AppBar(
        title: const Text("Welcome 🌊", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.quiz_rounded, color: Color(0xFF8FBC8F), size: 60),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Trivio",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Debug Your Limits",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Color(0xFF8FBC8F)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAccountPage())),
              child: const Text("Create Account", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
              child: const Text("Already have an account? Login", style: TextStyle(fontSize: 16, color: Color(0xFF003366))),
            ),
          ],
        ),
      ),
    );
  }
}
