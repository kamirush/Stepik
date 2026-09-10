import 'package:flutter_test/flutter_test.dart';

import 'package:form_example/main.dart';

void main() {
  testWidgets('shows the registration form', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Register Form'), findsOneWidget);
  });
}
