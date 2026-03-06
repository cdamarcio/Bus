import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Verifica permissões e captura a posição atual [RF-004]
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Verifica se o serviço de GPS está ativo no tablet
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('O GPS está desativado no dispositivo.');
    }

    // 2. Gerencia as permissões de localização [RNF-003]
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização negada permanentemente.');
    }

    // 3. Captura a coordenada com alta precisão para auditoria
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}