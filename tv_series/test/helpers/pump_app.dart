import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

String routeLabel(String name, [Object? arguments]) => 'route:$name:$arguments';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget home, {required List<BlocProvider> providers}) {
    var isInitialRoute = true;

    Widget buildPage(RouteSettings settings) {
      if (isInitialRoute) {
        isInitialRoute = false;
        return home;
      }
      return Scaffold(
        body: Text(routeLabel(settings.name!, settings.arguments)),
      );
    }

    return pumpWidget(
      MultiBlocProvider(
        providers: providers,
        child: MaterialApp(
          navigatorObservers: [routeObserver],
          onGenerateRoute: (settings) {
            final page = buildPage(settings);
            return MaterialPageRoute(settings: settings, builder: (_) => page);
          },
        ),
      ),
    );
  }

  Future<void> pumpTransition() async {
    await pump();
    await pump(const Duration(seconds: 1));
  }
}
