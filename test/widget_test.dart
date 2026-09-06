import 'package:flutter_test/flutter_test.dart';
import 'package:measures_converter/main.dart';

void main() {
  testWidgets('Measures Converter smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MeasuresConverterApp());
    expect(find.text('Measures Converter'), findsOneWidget);
    expect(find.text('Value'), findsOneWidget);
    expect(find.text('Convert'), findsOneWidget);
  });
}
