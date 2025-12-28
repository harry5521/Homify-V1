import 'package:flutter/material.dart';
import 'screens/register.dart'; 
import 'screens/login.dart'; 
import 'screens/splash_screen.dart';
import 'screens/provider_dashboard.dart';
import 'screens/service_management.dart';
import 'screens/add_service_page.dart';
import 'screens/provider_profile_page.dart';
import 'screens/customer_dashboard.dart';
import 'screens/customer_profile_page.dart';
import 'screens/find_services_page.dart';
// import 'screens/verification_page.dart';

// Logo View
// import 'screens/logo_view.dart';

// Firebase Integration
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
       
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/provider_dashboard': (context) => const ProviderDashboard(),
        '/service_management': (context) => const ServiceManagementPage(),
        '/add_service_page': (context) => const AddServicePage(),
        '/provider_profile_page': (context) => const ProviderProfilePage(),
        '/customer_dashboard': (context) => const CustomerDashboard(),
        '/customer_profile_page': (context) => const CustomerProfilePage(),
        '/find_services': (context) => const FindServicesPage(),
        // '/verification_page': (context) => const VerificationPage(),

        // Logo View
        // '/logo_view': (context) => const LogoView(),
        
      },
    );
  }
}
