import 'package:flutter_test/flutter_test.dart';
import 'package:smart_room_ar/main.dart';

void main() {
  testWidgets('SmartRoomApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartRoomApp(showOnboarding: false));
    await tester.pump();
    expect(find.byType(SmartRoomApp), findsOneWidget);
  });
}
