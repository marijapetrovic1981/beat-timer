import 'package:flutter_test/flutter_test.dart';
import 'package:beat_timer/main.dart';

void main() {
  testWidgets('App should build successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const BeatTimerApp());
    expect(find.text('Beat Timer'), findsOneWidget);
  });
}
