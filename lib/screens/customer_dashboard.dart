import 'package:flutter/material.dart';
import 'customer_profile_page.dart'; // Ensure this is imported

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Portal", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
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

            // 1. Customer Profile Button (Fixed Navigation)
            _buildDashboardButton(
              context,
              "Customer Profile",
              Icons.person_pin,
              const CustomerProfilePage(), // Pass the actual Page Widget here
            ),

            const SizedBox(height: 20),

            // 2. Find Services Button (Placeholder for now)
            _buildDashboardButton(
              context,
              "Find Services",
              Icons.search,
              null, // We will create this page next
            ),
          ],
        ),
      ),
    );
  }

  // Updated Helper Method
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
      ),
    );
  }
}