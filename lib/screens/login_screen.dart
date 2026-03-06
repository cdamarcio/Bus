import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho com Identidade Visual (Cores de Conceição do Araguaia)
            Container(
              height: 320,
              decoration: const BoxDecoration(
                color: Color(0xFF008000), // Verde do Brasão 
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bus_alert_rounded, size: 90, color: Colors.white),
                    const SizedBox(height: 15),
                    const Text(
                      "FROTA ESCOLAR",
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2
                      ),
                    ),
                    Text(
                      "Prefeitura de Conceição do Araguaia",
                      style: TextStyle(
                        color: Colors.yellow[600], // Amarelo do Brasão 
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de Matrícula (Login via JWT previsto no RNF-003) [cite: 48]
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Matrícula do Monitor',
                        labelStyle: const TextStyle(color: Color(0xFF0000FF)), // Azul 
                        prefixIcon: const Icon(Icons.badge, color: Color(0xFF0000FF)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF008000), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    
                    // Campo de Senha
                    TextFormField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'Senha de Acesso',
                        labelStyle: const TextStyle(color: Color(0xFF0000FF)),
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0000FF)),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _isObscure = !_isObscure),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Botão de Login - Interface de alto contraste 
                    SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008000), // Verde
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                        ),
                        onPressed: () {
                          // Navega para a Dashboard (Próxima etapa do fluxo)
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        },
                        child: const Text(
                          "ACESSAR SISTEMA",
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}