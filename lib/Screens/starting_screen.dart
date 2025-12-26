import 'package:flutter/material.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF233A66),
      body: Center(
        child: Text(
          'CommuteCampusx',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
