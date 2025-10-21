import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Factify", style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF000000))),
        centerTitle: true,
        backgroundColor:Color(0xFFFFFFFF)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Welcome to Factify!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your dashboard will appear here.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Example button action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("This is a placeholder action!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text("Explore Features", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
