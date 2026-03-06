import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _realizarLogin() {
    // [RNF-003] Simulação de Autenticação Segura via JWT
    if (_userController.text == "admin" && _passController.text == "123") {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciais inválidas!"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Logo ou Ícone da Prefeitura [RNF-002]
            const Icon(Icons.directions_bus, size: 100, color: Color(0xFF008000)),
            const SizedBox(height: 20),
            const Text(
              "FROTA ESCOLAR",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF008000)),
            ),
            const Text("Conceição do Araguaia - PA", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 50),
            
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: "Usuário/CPF",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _realizarLogin,
                child: const Text(
                  "ACESSAR SISTEMA",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}