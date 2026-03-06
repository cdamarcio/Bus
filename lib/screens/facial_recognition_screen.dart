import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
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
    
    // [AUTO-DETECT] Força a detecção após 5 segundos para a Web
    _simulationTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_isStudentDetected) {
        _forçarDeteccao();
      }
    });
  }

  void _forçarDeteccao() {
    setState(() => _isStudentDetected = true);
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _controller = CameraController(cameras[0], ResolutionPreset.low);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("Câmera não disponível ou bloqueada no navegador.");
    }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel(); 
    _controller?.dispose();
    super.dispose();
  }

  // [RF-004] Registro de Embarque com Geotagging e Trava de Timeout
  Future<void> _confirmarEmbarque() async {
    setState(() => _isLoading = true);
    
    try {
      // Tenta obter o GPS com timeout de 3 segundos para não travar na Web
      final position = await LocationService().getCurrentLocation()
          .timeout(const Duration(seconds: 3), onTimeout: () => null);

      // Coordenada real ou padrão de Conceição do Araguaia
      double lat = position?.latitude ?? -8.2575;
      double lng = position?.longitude ?? -49.2618;

      // Salva no SQLite local
      await DatabaseHelper().registrarEmbarque(_mockMatricula, lat, lng);

      if (!mounted) return;
      
      // Feedback e fechamento da tela
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Embarque de Felipe registrado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      // SAI DA TELA E VOLTA PRO DASHBOARD
      Navigator.pop(context); 

    } catch (e) {
      debugPrint("Erro no registro: $e");
      if (mounted) Navigator.pop(context); // Garante que sai da tela mesmo com erro
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Validação Facial - SEMEC"),
        backgroundColor: const Color(0xFF008000),
      ),
      // Toque em qualquer lugar para forçar o reconhecimento se o timer falhar
      body: GestureDetector(
        onTap: _isStudentDetected ? null : _forçarDeteccao,
        child: Stack(
          children: [
            // Câmera ou Fundo de Simulação
            _controller != null && _controller!.value.isInitialized
                ? SizedBox.expand(child: CameraPreview(_controller!))
                : Container(
                    color: Colors.black87,
                    child: const Center(
                      child: Text(
                        "Aguardando Câmera...\n(Ou toque para simular detecção)",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

            // Moldura Guia
            Center(
              child: Container(
                width: 260,
                height: 340,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isStudentDetected ? Colors.green : Colors.white70, 
                    width: 4
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            if (_isStudentDetected) _buildConfirmationOverlay(),
          ],
        ),
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
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 15),
              const Text("ALUNO IDENTIFICADO", style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                _mockStudentName, 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
              Text(_mockStudentSchool, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 25),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                    onPressed: _confirmarEmbarque,
                    child: const Text(
                      "CONFIRMAR EMBARQUE", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                    ),
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