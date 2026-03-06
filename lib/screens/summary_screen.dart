import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// Importações padronizadas seguindo a arquitetura 'bus'
import 'package:bus/models/aluno_model.dart';
import 'package:bus/database/database_helper.dart';
import 'package:bus/services/api_service.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  List<AlunoModel> _alunosEmbarcados = [];
  bool _isSyncing = false;

  // Coordenadas da Escola Municipal Deuzuita (Exemplo CDA)
  final double schoolLat = -8.2575; 
  final double schoolLng = -49.2618;

  @override
  void initState() {
    super.initState();
    _carregarResumo();
  }

  Future<void> _carregarResumo() async {
    final todosAlunos = await DatabaseHelper().getAlunos();
    setState(() {
      _alunosEmbarcados = todosAlunos.where((a) => a.embarcado).toList();
    });
  }

  // [RF-005] Lógica de Geofencing: Detecta chegada na escola
  Future<void> _verificarChegadaNaEscola() async {
    Position position = await Geolocator.getCurrentPosition();
    
    // Calcula distância em metros entre o ônibus e a escola
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude, 
      position.longitude, 
      schoolLat, 
      schoolLng
    );

    if (distanceInMeters < 100) { // Raio de 100 metros
      _mostrarAlertaChegada();
    }
  }

  void _mostrarAlertaChegada() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🚌 Chegada na Escola Deuzuita detectada!"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Future<void> _finalizarESincronizar() async {
    setState(() => _isSyncing = true);
    
    // [RF-001] Envia os logs com GPS para a SEMEC
    bool sucesso = await ApiService().sincronizarDadosComSEMEC(_alunosEmbarcados);

    setState(() => _isSyncing = false);

    if (sucesso) {
      _mostrarSucesso();
    }
  }

  void _mostrarSucesso() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Viagem Sincronizada!"),
        content: const Text("Os dados de auditoria foram enviados para a SEMEC com sucesso."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (r) => false),
            child: const Text("VOLTAR AO INÍCIO"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resumo da Viagem"),
        backgroundColor: const Color(0xFF008000), // Verde
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildStatCard("Alunos Transportados", _alunosEmbarcados.length.toString(), Icons.school),
            const SizedBox(height: 20),
            const Text("Lista de Embarque Confirmado:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _alunosEmbarcados.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(_alunosEmbarcados[index].nome),
                    subtitle: Text("GPS: ${_alunosEmbarcados[index].latitude?.toStringAsFixed(4)}, ${_alunosEmbarcados[index].longitude?.toStringAsFixed(4)}"),
                  );
                },
              ),
            ),
            const Divider(),
            if (_isSyncing)
              const CircularProgressIndicator()
            else
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _finalizarESincronizar,
                  icon: const Icon(Icons.cloud_upload, color: Colors.white),
                  label: const Text("FINALIZAR E ENVIAR DADOS", style: TextStyle(color: Colors.white, fontSize: 18)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0000FF)), // Azul
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withOpacity(0.2), // Amarelo suave
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFFD700)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 40, color: const Color(0xFF008000)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}