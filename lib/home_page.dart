import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'leaderboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> languages = [
    {"name": "Python", "image": "assets/python.png", "color": Color(0xFF3776AB)},
    {"name": "C++", "image": "assets/cpp.png", "color": Color(0xFF00599C)},
    {"name": "Java", "image": "assets/java.png", "color": Color(0xFF5382A1)},
    {"name": "C", "image": "assets/c.png", "color": Color(0xFF283593)},
    {"name": "Dart", "image": "assets/dart.png", "color": Color(0xFF0175C2)},
  ];

  // Quiz state
  List questions = [];
  int currentQuestion = 0;
  int score = 0;
  bool isQuiz = false;
  bool answered = false;
  String selectedLanguage = "";

  void _showProfile() async {
    var doc = await firestore.collection('users').doc(user!.uid).get();
    var data = doc.data();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF0F8F8),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle, size: 70, color: Color(0xFF003366)),
            const SizedBox(height: 10),
            Text(data?['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            const SizedBox(height: 5),
            Text(data?['email'] ?? '', style: const TextStyle(color: Colors.black54, fontSize: 16)),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8FBC8F)),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("Logout", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchQuestions(String lang) async {
    setState(() {
      isQuiz = true;
      selectedLanguage = lang;
      currentQuestion = 0;
      score = 0;
      answered = false;
      questions = [];
    });

    final url = Uri.parse('https://opentdb.com/api.php?amount=10&category=18&type=multiple');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        questions = data['results'];
      });
    }
  }

  void checkAnswer(String selected, String correct) {
    if (answered) return;
    setState(() {
      answered = true;
      if (selected == correct) score++;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
          answered = false;
        });
      } else {
        saveScore();
      }
    });
  }

  Future<void> saveScore() async {
    await firestore.collection('leaderboard').add({
      'uid': user!.uid,
      'name': user!.displayName ?? user!.email,
      'score': score,
      'language': selectedLanguage,
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LeaderboardPage(userScore: score, language: selectedLanguage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F8),
      appBar: AppBar(
        title: const Text("Trivio", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(icon: const Icon(Icons.account_circle, color: Colors.white), onPressed: _showProfile)
        ],
      ),
      floatingActionButton: !isQuiz
          ? FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8FBC8F),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardPage())),
        icon: const Icon(Icons.leaderboard_rounded, color: Colors.white),
        label: const Text("Leaderboard", style: TextStyle(color: Colors.white)),
      )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isQuiz
            ? buildQuiz()
            : GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final lang = languages[index];
            return GestureDetector(
              onTap: () => fetchQuestions(lang['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: lang['color'].withOpacity(0.85),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: lang['color'].withOpacity(0.3), blurRadius: 8, offset: const Offset(2, 4))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(lang['image'], height: 70),
                    const SizedBox(height: 10),
                    Text(lang['name'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildQuiz() {
    final q = questions[currentQuestion];
    List<String> options = List<String>.from(q['incorrect_answers']);
    options.add(q['correct_answer']);
    options.shuffle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (currentQuestion + 1) / questions.length,
          color: const Color(0xFF8FBC8F),
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 20),
        Text("Q${currentQuestion + 1}. ${q['question']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 25),
        ...options.map((opt) => GestureDetector(
          onTap: () => checkAnswer(opt, q['correct_answer']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: answered
                  ? opt == q['correct_answer']
                  ? const Color(0xFF8FBC8F)
                  : const Color(0xFFFF6F61)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(2, 3))],
            ),
            child: Text(opt, style: const TextStyle(fontSize: 16)),
          ),
        )),
        const Spacer(),
        Center(
          child: Text("Score: $score / ${questions.length}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366), fontSize: 18)),
        ),
      ],
    );
  }
}
