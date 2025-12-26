import 'package:flutter/material.dart';
import 'customer_profile_page.dart'; 
import 'find_services_page.dart';
import 'about_page.dart';
import 'auth_state.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Customer Portal", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        // FIXED: Replaced GestureDetector with IconButton for hover support
        leadingWidth: 80, 
        leading: IconButton(
          tooltip: 'About Us', // Adds the hover label like Logout
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            );
          },
          icon: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.white, size: 22),
              Text(
                "About Us",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 10, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              SessionManager.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
            },           
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.hail, size: 100, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              "Hello, User!\nWhat are you looking for today?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 40),

            _buildDashboardButton(
              context,
              "Customer Profile",
              Icons.person_pin,
              const CustomerProfilePage(),
            ),

            const SizedBox(height: 20),

            _buildDashboardButton(
              context,
              "Find Services",
              Icons.search,
              const FindServicesPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title, IconData icon, Widget? destinationPage) {
    return ElevatedButton.icon(
      onPressed: () {
        if (destinationPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Service Search coming soon!")),
          );
        }
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // Ensures the cursor changes to a pointer on web/desktop
        enabledMouseCursor: SystemMouseCursors.click, 
      ),
    );
  }
}