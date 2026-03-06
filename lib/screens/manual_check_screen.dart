import 'package:flutter/material.dart';
// Importação padronizada do modelo e banco
import 'package:bus/models/aluno_model.dart';
import 'package:bus/database/database_helper.dart';

class ManualChecklistScreen extends StatefulWidget {
  const ManualChecklistScreen({super.key});

  @override
  State<ManualChecklistScreen> createState() => _ManualChecklistScreenState();
}

class _ManualChecklistScreenState extends State<ManualChecklistScreen> {
  List<AlunoModel> _alunos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  // [RF-003] Carrega lista do SQLite para Fallback Manual
  Future<void> _carregarAlunos() async {
    final dados = await DatabaseHelper().getAlunos();
    setState(() {
      _alunos = dados;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chamada Manual [RF-003]"),
        backgroundColor: const Color(0xFF0000FF), // Azul
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemCount: _alunos.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final aluno = _alunos[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: aluno.embarcado ? Colors.green : Colors.grey,
                  child: Icon(
                    aluno.embarcado ? Icons.check : Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(aluno.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${aluno.escola} - ${aluno.pontoParada}"),
                trailing: Checkbox(
                  value: aluno.embarcado,
                  onChanged: (bool? value) async {
                    if (value == true) {
                      // Registra embarque manual com coordenadas 0.0 (Sem GPS preciso no manual)
                      await DatabaseHelper().registrarEmbarque(aluno.matricula, 0.0, 0.0);
                      _carregarAlunos();
                    }
                  },
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/summary'),
        label: const Text("FECHAR VIAGEM"),
        icon: const Icon(Icons.stop),
        backgroundColor: Colors.red,
      ),
    );
  }
}