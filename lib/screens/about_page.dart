import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Homify", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            
            // 1. MAIN LOGO
            Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_work_rounded, 
                  size: 80, 
                  color: Colors.teal,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            const Text(
              "HOMIFY",
              style: TextStyle(
                fontSize: 30, 
                fontWeight: FontWeight.w900, 
                color: Colors.teal, 
                letterSpacing: 3
              ),
            ),
            const Text("Version 1.0.0", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),

            const SizedBox(height: 40),

            // 2. TAGLINE & DESCRIPTION (REARRANGED)
            const Text(
              "Expertise at Your Door",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Experience the future of home maintenance. Connecting you to the Excellence.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.6),
              ),
            ),

            const SizedBox(height: 40),

            // 3. FEATURE ICONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildModernFeature(Icons.bolt_rounded, "Fast"),
                _buildModernFeature(Icons.verified_user_rounded, "Secure"),
                _buildModernFeature(Icons.phone_in_talk_rounded, "Call"),
              ],
            ),

            const SizedBox(height: 30),

            // 4. BRANDING FOOTER
            const Divider(indent: 60, endIndent: 60),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.teal.withOpacity(0.1)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Developed By NHA SoftTech",
                    style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.auto_awesome, color: Colors.teal, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFeature(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.teal, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 13),
        ),
      ],
    );
  }
}