import 'package:flutter/material.dart';
import 'package:bus/database/database_helper.dart';
import 'package:bus/database/mock_data_injector.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isDataLoaded = false;

  // Função para injetar os dados de teste (Obrigatório antes de iniciar)
  Future<void> _sincronizarDados() async {
    setState(() => _isDataLoaded = false);
    
    // Injeta o Felipe Rodrigues no banco local
    await MockDataInjector.inject();
    
    setState(() => _isDataLoaded = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Dados da SEMEC sincronizados com sucesso!"),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel de Controle - CDA"),
        backgroundColor: const Color(0xFF008000),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _sincronizarDados,
            tooltip: "Sincronizar Alunos",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 30),
            
            // Botão Principal: Só funciona bem se os dados estiverem carregados
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008000),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              icon: const Icon(Icons.camera_front, color: Colors.white, size: 30),
              label: const Text(
                "INICIAR EMBARQUE (IA)",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Navega direto para a tela de reconhecimento
                Navigator.pushNamed(context, '/facial_recognition');
              },
            ),
            
            const SizedBox(height: 15),
            
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Color(0xFF0000FF)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              icon: const Icon(Icons.list_alt, color: Color(0xFF0000FF)),
              label: const Text("CHAMADA MANUAL", style: TextStyle(color: Color(0xFF0000FF))),
              onPressed: () => Navigator.pushNamed(context, '/manual_check'),
            ),

            const Spacer(),
            
            if (!_isDataLoaded)
              const Text(
                "⚠️ Atenção: Clique no ícone de sincronizar (topo) antes de iniciar.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Veículo:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("ÔNIBUS 04 - ROTA RURAL"),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Monitor:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Márcio Rodrigues"),
            ],
          ),
        ],
      ),
    );
  }
}