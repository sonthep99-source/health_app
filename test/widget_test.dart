import 'package:flutter_test/flutter_test.dart';
import 'package:health_app/main.dart';

void main() {
  testWidgets('HealthQuest Gamified App loads successfully with 5 main tabs', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title and bottom navigation tabs appear.
    expect(find.text('Health Dashboard'), findsOneWidget);
    expect(find.text('แดชบอร์ด'), findsOneWidget);
    expect(find.text('Food AI'), findsOneWidget);
    expect(find.text('Trackers'), findsOneWidget);
    expect(find.text('Pet Room'), findsOneWidget);
    expect(find.text('Shop & AI'), findsOneWidget);
  });
}
