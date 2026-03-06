import 'package:flutter/material.dart';
// Novos caminhos após a organização das pastas 
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/facial_recognition_screen.dart';
import 'screens/manual_check_screen.dart';
import 'screens/summary_screen.dart'; 

void main() {
  runApp(const FrotaEscolarApp());
}

class FrotaEscolarApp extends StatelessWidget {
  const FrotaEscolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoramento Frota CDA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF008000), // Verde [cite: 41]
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/facial_recognition': (context) => const FacialRecognitionScreen(),
        '/manual_check': (context) => const ManualChecklistScreen(),
        '/summary': (context) => const SummaryScreen(),
      },
    );
  }
}