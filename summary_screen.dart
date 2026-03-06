import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resumo da Viagem [RF-006]"),
        backgroundColor: const Color(0xFF008000), // Verde [cite: 41]
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text("Rota Finalizada com Sucesso!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Divider(height: 40),
            
            // Relatório de Auditoria Local 
            _reportRow("Alunos Presentes:", "42"),
            _reportRow("Alunos Ausentes:", "03"),
            _reportRow("Quilometragem:", "24.5 KM"),
            
            const Spacer(),
            
            // Botão de Sincronização Final (Geofencing) [cite: 32]
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0000FF)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dados enviados para SEMEC!")));
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                icon: const Icon(Icons.cloud_upload, color: Colors.white),
                label: const Text("SINCRONIZAR E FINALIZAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}