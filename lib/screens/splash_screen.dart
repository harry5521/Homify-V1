import 'dart:async'; // Added for Future/Timer logic
import 'package:flutter/material.dart';
// Remove or fix these imports based on your actual file names
// import 'role_selection_screen.dart'; 
// import 'screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Changed duration to 5 seconds as you requested
    Future.delayed(const Duration(seconds: 3), () {
      // Check if the widget is still in the tree before navigating
      if (mounted) {
        // Use pushReplacementNamed to match your main.dart route table
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal, // You can change this to Colors.indigo to match your theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Added an icon to make it look like a real splash screen        
           Icon(Icons.home_work_rounded, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'HomiFy',
              style: TextStyle(
                fontSize: 32, 
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}