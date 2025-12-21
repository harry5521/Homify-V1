import 'package:flutter/material.dart';
// Screens
import 'screens/register.dart'; 
import 'screens/login.dart'; 
import 'screens/splash_screen.dart';
// Provider Screens
import 'screens/provider_dashboard.dart';
import 'screens/service_management.dart';
import 'screens/add_service_page.dart';
import 'screens/provider_profile_page.dart';
// Customer Screens
import 'screens/customer_dashboard.dart';
import 'screens/customer_profile_page.dart';

void main() {
  runApp(const HomifyApp());
}

class HomifyApp extends StatelessWidget {
  const HomifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set to Teal for consistent branding
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        // Common Routes
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),

        // Provider Routes
        '/provider_dashboard': (context) => const ProviderDashboard(),
        '/service_management': (context) => const ServiceManagementPage(),
        '/add_service_page': (context) => const AddServicePage(),
        '/provider_profile_page': (context) => const ProviderProfilePage(),

        // Customer Routes
        '/customer_dashboard': (context) => const CustomerDashboard(),
        '/customer_profile_page': (context) => const CustomerProfilePage(),
        
      },
    );
  }
}
