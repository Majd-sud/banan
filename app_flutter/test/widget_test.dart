import 'package:flutter_test/flutter_test.dart';
import 'package:app_flutter/main.dart';

void main() {
  testWidgets('Banan app builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const BananApp());

    // Check that login screen text is there
    expect(find.text('Banān – Login'), findsOneWidget);
  });
}
