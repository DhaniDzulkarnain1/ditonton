import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should display the title and notify when see more is tapped', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SubHeading(title: 'Popular', onTap: () => tapCount++),
        ),
      ),
    );
    await tester.tap(find.text('See More'));

    expect(find.text('Popular'), findsOneWidget);
    expect(tapCount, 1);
  });
}
