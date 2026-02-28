// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:city_library/main.dart';

void main() {
  testWidgets('MyApp has a title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('City Library'), findsWidgets);
  });
}