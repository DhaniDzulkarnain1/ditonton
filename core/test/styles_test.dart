import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('text theme should use the shared text styles', () {
    expect(kTextTheme.headlineMedium, kHeading5);
    expect(kTextTheme.headlineSmall, kHeading6);
    expect(kTextTheme.labelMedium, kSubtitle);
    expect(kTextTheme.bodyMedium, kBodyText);
  });

  test('color scheme should be dark with the brand colors', () {
    expect(kColorScheme.brightness, Brightness.dark);
    expect(kColorScheme.primary, kMikadoYellow);
    expect(kColorScheme.surface, kRichBlack);
    expect(kDrawerTheme.backgroundColor, Colors.grey.shade700);
  });

  test('route observer should be shared across modules', () {
    expect(routeObserver, isA<RouteObserver<ModalRoute>>());
  });
}
