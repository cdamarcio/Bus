import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isSyncing = false;
  double _syncProgress = 0.0;

  // Simulação do RF-001: Sincronização de Dados
  void _startSync() async {
    setState(() {
      _isSyncing = true;
      _syncProgress = 0.0;
    });

    // Simulando o download de vetores faciais e rotas (Downstream)
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _syncProgress = i / 10;
      });
    }

    setState(() {
      _isSyncing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Dados da SEMEC sincronizados com sucesso! (Modo Offline Ativo)"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel do Monitor"),
        backgroundColor: const Color(0xFF008000), // Verde [cite: 41]
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status do Veículo e Rota
            _buildInfoCard("Veículo:", "Ônibus Escolar 04", Icons.directions_bus),
            _buildInfoCard("Rota Atual:", "Zona Rural - P.A. Joncon", Icons.map),
            
            const SizedBox(height: 30),
            const Text(
              "Sincronização Necessária [RF-001]",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Área de Sincronização [cite: 14, 17]
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  if (_isSyncing) ...[
                    LinearProgressIndicator(value: _syncProgress, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text("Baixando lista de alunos e fotos... ${( _syncProgress * 100).toInt()}%"),
                  ] else ...[
                    const Text("Última sincronização: Hoje, 07:30h"),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: _startSync,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0000FF), // Azul [cite: 41]
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.cloud_download, color: Colors.white),
                        label: const Text("SINCRONIZAR COM SEMEC", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Spacer(),

            // Botão Principal para Iniciar Viagem
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/facial_recognition');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 40, color: Colors.white),
                    SizedBox(width: 15),
                    Text("INICIAR ROTA DE EMBARQUE", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF008000)),
        title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }
}