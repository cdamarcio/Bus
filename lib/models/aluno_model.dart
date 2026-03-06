import '../models/aluno_model.dart';

class ApiService {
  // Simula o endpoint GET/api/rotas/{id_veiculo}/alunos [cite: 57]
  Future<List<AlunoModel>> fetchAlunosFromSEMEC() async {
    // Simulando atraso de rede
    await Future.delayed(const Duration(seconds: 2));

    // Dados Mockados seguindo o requisito de Downstream [cite: 14]
    return [
      AlunoModel(
        nome: "Felipe Rodrigues",
        matricula: "2024005",
        fotoHash: "v_fac_005_xyz", // Vetor facial para reconhecimento 
        escola: "Escola Municipal Deuzuita",
        pontoParada: "Setor Aeroporto",
      ),
      AlunoModel(
        nome: "Ana Clara Souza",
        matricula: "2024001",
        fotoHash: "v_fac_001_abc",
        escola: "Escola Municipal Deuzuita",
        pontoParada: "Setor Central",
      ),
    ];
  }

  // Simula o endpoint POST/api/viagens/sincronizar [cite: 58]
  Future<bool> syncUpstream(List<Map<String, dynamic>> logs) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simula o envio bem sucedido para o Banco Central PostgreSQL [cite: 59]
    return true;
  }
}