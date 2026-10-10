import 'package:core/core.dart';
import 'package:ditonton/app.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

import 'helpers/fake_tmdb_client.dart';

void main() {
  setUp(() {
    final databaseHelper = _MockDatabaseHelper();
    when(() => databaseHelper.getWatchlist(any())).thenAnswer((_) async => []);
    when(
      () => databaseHelper.getWatchlistById(any(), any()),
    ).thenAnswer((_) async => null);

    di.init(httpClient: createFakeTmdbClient());
    di.locator.unregister<DatabaseHelper>();
    di.locator.registerLazySingleton<DatabaseHelper>(() => databaseHelper);
  });

  tearDown(() => di.locator.reset());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const DitontonApp());
    await tester.pump();
  }

  Future<void> openRoute(
    WidgetTester tester,
    String route, {
    Object? arguments,
  }) async {
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(route, arguments: arguments);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('should start on the movie home page', (tester) async {
    await pumpApp(tester);

    expect(find.byType(HomeMoviePage), findsOneWidget);
    expect(find.text('Now Playing'), findsOneWidget);
  });

  final routes = <String, Type>{
    popularMoviesRoute: PopularMoviesPage,
    topRatedMoviesRoute: TopRatedMoviesPage,
    searchMoviesRoute: MovieSearchPage,
    watchlistMoviesRoute: WatchlistMoviesPage,
    homeTvSeriesRoute: HomeTvSeriesPage,
    onTheAirTvSeriesRoute: OnTheAirTvSeriesPage,
    popularTvSeriesRoute: PopularTvSeriesPage,
    topRatedTvSeriesRoute: TopRatedTvSeriesPage,
    searchTvSeriesRoute: TvSeriesSearchPage,
    watchlistTvSeriesRoute: WatchlistTvSeriesPage,
    aboutRoute: AboutPage,
  };

  for (final route in routes.entries) {
    testWidgets('should open ${route.value} for ${route.key}', (tester) async {
      await pumpApp(tester);

      await openRoute(tester, route.key);

      expect(find.byType(route.value), findsOneWidget);
    });
  }

  testWidgets('should open movie detail with the given id', (tester) async {
    await pumpApp(tester);

    await openRoute(tester, movieDetailRoute, arguments: 557);

    final page = tester.widget<MovieDetailPage>(find.byType(MovieDetailPage));
    expect(page.id, 557);
  });

  testWidgets('should open TV series detail with the given id', (tester) async {
    await pumpApp(tester);

    await openRoute(tester, tvSeriesDetailRoute, arguments: 1396);

    final page = tester.widget<TvSeriesDetailPage>(
      find.byType(TvSeriesDetailPage),
    );
    expect(page.id, 1396);
  });

  testWidgets('should show a fallback page for an unknown route', (
    tester,
  ) async {
    await pumpApp(tester);

    await openRoute(tester, '/unknown');

    expect(find.text('Page not found :('), findsOneWidget);
  });

  testWidgets('should notify the given navigator observers', (tester) async {
    final observer = _RecordingObserver();
    await tester.pumpWidget(DitontonApp(navigatorObservers: [observer]));
    await tester.pump();

    await openRoute(tester, aboutRoute);

    expect(observer.pushedRoutes, [homeMovieRoute, aboutRoute]);
  });
}

class _MockDatabaseHelper extends Mock implements DatabaseHelper {}

class _RecordingObserver extends NavigatorObserver {
  final List<String?> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route.settings.name);
  }
}
