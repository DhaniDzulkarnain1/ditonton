import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpPage(WidgetTester tester, {VoidCallback? onTestCrash}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AboutPage(onTestCrash: onTestCrash),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }

  Future<void> openPage(WidgetTester tester) async {
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('should display the app description and logo', (tester) async {
    await pumpPage(tester);
    await openPage(tester);

    expect(find.byType(Image), findsOneWidget);
    expect(find.textContaining('Ditonton merupakan'), findsOneWidget);
    expect(find.text('Test Crashlytics'), findsNothing);
  });

  testWidgets('should go back when the back button is tapped', (tester) async {
    await pumpPage(tester);
    await openPage(tester);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsNothing);
  });

  testWidgets('should trigger the crash callback when it is provided', (
    tester,
  ) async {
    var crashCount = 0;
    await pumpPage(tester, onTestCrash: () => crashCount++);
    await openPage(tester);

    await tester.tap(find.text('Test Crashlytics'));

    expect(crashCount, 1);
  });
}
