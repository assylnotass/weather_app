import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('hello world widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Text('Hello, World!'))));
    expect(find.text('Hello, World!'), findsOneWidget);
  });
}