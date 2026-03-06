import 'package:flutter/material.dart';

class ManualChecklistScreen extends StatefulWidget {
  const ManualChecklistScreen({super.key});

  @override
  State<ManualChecklistScreen> createState() => _ManualChecklistScreenState();
}

class _ManualChecklistScreenState extends State<ManualChecklistScreen> {
  // Simulação de dados vindos do SQLite [RF-001]
  final List<Map<String, dynamic>> _alunos = [
    {"nome": "Ana Clara Souza", "matricula": "2024001", "embarcado": false},
    {"nome": "Bruno Oliveira", "matricula": "2024002", "embarcado": true},
    {"nome": "Carlos Eduardo", "matricula": "2024003", "embarcado": false},
    {"nome": "Daniela Lima", "matricula": "2024004", "embarcado": false},
    {"nome": "Felipe Rodrigues", "matricula": "2024005", "embarcado": false},
  ];

  List<Map<String, dynamic>> _filteredAlunos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredAlunos = _alunos;
  }

  void _filterAlunos(String query) {
    setState(() {
      _filteredAlunos = _alunos
          .where((aluno) => aluno['nome'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chamada Manual"),
        backgroundColor: const Color(0xFF0000FF), // Azul conforme RF-003
      ),
      body: Column(
        children: [
          // Barra de Busca para agilizar localização [RF-003]
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterAlunos,
              decoration: InputDecoration(
                labelText: "Buscar aluno por nome...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: _filteredAlunos.length,
              itemBuilder: (context, index) {
                final aluno = _filteredAlunos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: aluno['embarcado'] ? Colors.green : Colors.grey,
                      child: Text(aluno['nome'][0], style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      aluno['nome'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Matrícula: ${aluno['matricula']}"),
                    trailing: Transform.scale(
                      scale: 1.5, // Checkbox maior para facilitar o toque [RNF-002]
                      child: Checkbox(
                        value: aluno['embarcado'],
                        activeColor: Colors.green,
                        onChanged: (bool? value) {
                          setState(() {
                            aluno['embarcado'] = value!;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Botão de Finalizar Chamada
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008000), // Verde
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("CONCLUIR LISTAGEM", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}