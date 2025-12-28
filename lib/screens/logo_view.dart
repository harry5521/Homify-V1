import 'package:flutter/material.dart';

class LogoView extends StatelessWidget {
  const LogoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This removes any status bars so the screenshot is clean
      backgroundColor: Colors.teal,
      body: Center(
        child: Icon(
          Icons.home_work_rounded,
          size: 180, // Large enough for a high-quality screenshot
          color: Colors.white,
        ),
      ),
    );
  }
}