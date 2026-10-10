import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String routeLabel(String name) => 'route:$name';

  Future<void> pumpDrawer(WidgetTester tester, String currentRoute) async {
    var isInitialRoute = true;

    Widget buildPage(RouteSettings settings) {
      if (isInitialRoute) {
        isInitialRoute = false;
        return Scaffold(
          appBar: AppBar(),
          drawer: AppDrawer(
            currentRoute: currentRoute,
            watchlistRoute: watchlistMoviesRoute,
          ),
        );
      }
      return Scaffold(body: Text(routeLabel(settings.name!)));
    }

    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          final page = buildPage(settings);
          return MaterialPageRoute(settings: settings, builder: (_) => page);
        },
      ),
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
  }

  Future<void> tapMenu(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('should display the app identity and menu items', (tester) async {
    await pumpDrawer(tester, homeMovieRoute);

    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.text('ditonton@dicoding.com'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('should close the drawer when the current home is selected', (
    tester,
  ) async {
    await pumpDrawer(tester, homeMovieRoute);

    await tapMenu(tester, 'Movies');

    expect(find.byType(AppDrawer), findsNothing);
    expect(find.text(routeLabel(homeMovieRoute)), findsNothing);
  });

  testWidgets('should open the other home when it is selected', (tester) async {
    await pumpDrawer(tester, homeMovieRoute);

    await tapMenu(tester, 'TV Series');

    expect(find.text(routeLabel(homeTvSeriesRoute)), findsOneWidget);
  });

  testWidgets('should open movie home from the TV series drawer', (
    tester,
  ) async {
    await pumpDrawer(tester, homeTvSeriesRoute);

    await tapMenu(tester, 'Movies');

    expect(find.text(routeLabel(homeMovieRoute)), findsOneWidget);
  });

  testWidgets('should open the given watchlist route', (tester) async {
    await pumpDrawer(tester, homeMovieRoute);

    await tapMenu(tester, 'Watchlist');

    expect(find.text(routeLabel(watchlistMoviesRoute)), findsOneWidget);
  });

  testWidgets('should open the about page', (tester) async {
    await pumpDrawer(tester, homeMovieRoute);

    await tapMenu(tester, 'About');

    expect(find.text(routeLabel(aboutRoute)), findsOneWidget);
  });
}
