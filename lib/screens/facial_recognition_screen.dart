import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async'; // Necessário para o Timer de simulação
// Importações padronizadas
import 'package:bus/database/database_helper.dart';
import 'package:bus/services/location_service.dart';

class FacialRecognitionScreen extends StatefulWidget {
  const FacialRecognitionScreen({super.key});

  @override
  State<FacialRecognitionScreen> createState() => _FacialRecognitionScreenState();
}

class _FacialRecognitionScreenState extends State<FacialRecognitionScreen> {
  CameraController? _controller;
  bool _isStudentDetected = false;
  bool _isLoading = false;
  Timer? _simulationTimer;
  
  // Aluno mockado para a demonstração
  final String _mockMatricula = "2024005";
  final String _mockStudentName = "Felipe Rodrigues";
  final String _mockStudentSchool = "Escola Municipal Deuzuita";

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});

      // INÍCIO DA SIMULAÇÃO: Após 4 segundos com a câmera aberta, o sistema "reconhece" o aluno
      _simulationTimer = Timer(const Duration(seconds: 4), () {
        if (mounted && !_isStudentDetected) {
          setState(() => _isStudentDetected = true);
        }
      });
    } catch (e) {
      debugPrint("Erro ao inicializar câmera: $e");
    }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel(); // Cancela o timer ao sair da tela
    _controller?.dispose();
    super.dispose();
  }

  // [RF-004] Registro de Embarque com Geotagging
  Future<void> _confirmarEmbarque() async {
    setState(() => _isLoading = true);
    try {
      // Captura a localização (No navegador, pedirá permissão de GPS)
      final position = await LocationService().getCurrentLocation();

      await DatabaseHelper().registrarEmbarque(
        _mockMatricula, 
        position?.latitude ?? 0.0, 
        position?.longitude ?? 0.0
      );

      if (!mounted) return;
      Navigator.pop(context); // Volta ao Dashboard
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Embarque de Felipe registrado com GPS!"), backgroundColor: Colors.green),
      );
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Validação Facial - SEMEC"),
        backgroundColor: const Color(0xFF008000),
      ),
      body: Stack(
        children: [
          // Visualização da Câmera
          SizedBox.expand(child: CameraPreview(_controller!)),

          // Moldura de escaneamento
          Center(
            child: Container(
              width: 260,
              height: 340,
              decoration: BoxDecoration(
                border: Border.all(color: _isStudentDetected ? Colors.green : Colors.white, width: 4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: !_isStudentDetected 
                ? const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.bottom(20),
                      child: Text("Posicione o rosto", style: TextStyle(color: Colors.white, backgroundColor: Colors.black54)),
                    ),
                  )
                : null,
            ),
          ),

          // Modal de Confirmação (Aparece após 4 segundos ou detecção)
          if (_isStudentDetected) _buildConfirmationOverlay(),
        ],
      ),
    );
  }

  Widget _buildConfirmationOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 15),
              const Text("ALUNO RECONHECIDO", style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text(_mockStudentName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(_mockStudentSchool, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 25),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(15)),
                    onPressed: _confirmarEmbarque,
                    child: const Text("CONFIRMAR EMBARQUE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              TextButton(
                onPressed: () => setState(() => _isStudentDetected = false),
                child: const Text("TENTAR NOVAMENTE"),
              )
            ],
          ),
        ),
      ),
    );
  }
}