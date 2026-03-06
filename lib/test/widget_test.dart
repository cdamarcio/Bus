import 'package:flutter_test/flutter_test.dart';
import 'package:frota_escolar_cda/main.dart';

void main() {
  testWidgets('Verifica se a tela de login carrega o título corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const FrotaEscolarApp());

    // Verifica se o texto de boas-vindas da prefeitura aparece
    expect(find.text('FROTA ESCOLAR'), findsOneWidget);
    expect(find.text('ACESSAR SISTEMA'), findsOneWidget);
  });
}