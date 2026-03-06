import 'package:flutter/material.dart';
import '../database/mock_data_injector.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isSyncing = false;
  double _syncProgress = 0.0;
  final ApiService _apiService = ApiService();

  // [RF-001] Sincronização de Dados (Downstream)
  // Simula o download da lista de alunos e rotas da SEMEC para o SQLite local
  Future<void> _iniciarSincronizacao() async {
    setState(() {
      _isSyncing = true;
      _syncProgress = 0.1;
    });

    try {
      // Simula o delay de rede para baixar vetores faciais e rotas [cite: 16, 23]
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _syncProgress = 0.5);

      // Injeta os dados mockados no banco de dados local [cite: 18]
      await MockDataInjector.inject();
      
      setState(() => _syncProgress = 1.0);
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sincronização concluída! Dados prontos para uso offline."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na sincronização: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel de Controle - SEMEC", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF008000), // Verde 
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações da Rota e Veículo [cite: 4]
            _buildStatusCard("Veículo Escolar:", "Ônibus 04 - CDA", Icons.directions_bus),
            _buildStatusCard("Monitor Responsável:", "Marcio Rodrigues", Icons.person),
            
            const SizedBox(height: 30),
            const Text(
              "Sincronização de Dados [RF-001]",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Área de Sincronização e Progresso
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  if (_isSyncing) ...[
                    LinearProgressIndicator(value: _syncProgress, color: const Color(0xFF0000FF)), // Azul 
                    const SizedBox(height: 15),
                    Text("Baixando dados da SEMEC... ${(_syncProgress * 100).toInt()}%"),
                  ] else ...[
                    const Icon(Icons.cloud_done, color: Colors.green, size: 40),
                    const SizedBox(height: 10),
                    const Text("Pronto para iniciar a rota.", style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: _iniciarSincronizacao,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0000FF), // Azul 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.sync, color: Colors.white),
                        label: const Text("SINCRONIZAR AGORA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Spacer(),

            // [RNF-002] Botão de Iniciar Rota - Grande e Alto Contraste 
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/facial_recognition'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008000), // Verde 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_fill, size: 40, color: Colors.white),
                    SizedBox(width: 15),
                    Text("INICIAR EMBARQUE", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF008000).withOpacity(0.1),
          child: Icon(icon, color: const Color(0xFF008000)),
        ),
        title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}