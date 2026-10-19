import 'package:flutter_test/flutter_test.dart';
import 'package:health_app/main.dart';

void main() {
  testWidgets('Health Tracker app loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title and bottom navigation tabs appear.
    expect(find.text('Health Dashboard'), findsOneWidget);
    expect(find.text('แดชบอร์ด'), findsOneWidget);
    expect(find.text('ดื่มน้ำ'), findsOneWidget);
    expect(find.text('การนอน'), findsOneWidget);
    expect(find.text('ออกกำลังกาย'), findsOneWidget);
  });
}
