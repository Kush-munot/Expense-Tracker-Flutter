import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/transaction_dialog.dart'; // Import the relevant dependencies

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Test _newTransaction', (WidgetTester tester) async {
    final navigatorObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: HomePage(),
      navigatorObservers: [navigatorObserver],
    ));

    // Tap the floating action button to trigger the _newTransaction method
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the TransactionDialog was shown
    verify(navigatorObserver.didPush(
        any, any)); // Replace 'any' with the TransactionDialog type if possible
  });
}
