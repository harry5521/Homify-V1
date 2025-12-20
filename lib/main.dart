import 'package:flutter/material.dart';
// Import your register page file here
import 'screens/register.dart'; 
import 'screens/login.dart'; 
import 'screens/splash_screen.dart';
import 'screens/provider_dashboard.dart';
import 'screens/service_management.dart';

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
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // Set the starting page
      initialRoute: '/splash',
      // Define the routes map
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(), // The page we built earlier
        '/provider_dashboard': (context) => ProviderDashboard(), // The page we built earlier
        '/service_management': (context) => ServiceManagementPage(), // The page we built earlier
       

      },
    );
  }
}
