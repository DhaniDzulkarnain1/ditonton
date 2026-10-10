import 'package:core/core.dart';
import 'package:ditonton/app.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/widgets/movie_card.dart';
import 'package:movie/presentation/widgets/movie_poster_list.dart';
import 'package:tv_series/presentation/widgets/season_list.dart';
import 'package:tv_series/presentation/widgets/tv_series_card.dart';
import 'package:tv_series/presentation/widgets/tv_series_poster_list.dart';
import 'package:tv_series/tv_series.dart';

extension on WidgetTester {
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final end = binding.clock.now().add(timeout);
    while (finder.evaluate().isEmpty) {
      if (binding.clock.now().isAfter(end)) {
        fail('Timed out waiting for $finder');
      }
      await pump(const Duration(milliseconds: 200));
    }
  }

  Future<void> pumpFor(Duration duration) async {
    final end = binding.clock.now().add(duration);
    while (binding.clock.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> tapAndWait(Finder finder, Finder next) async {
    await tap(finder);
    await pumpUntilFound(next);
  }

  Future<void> openDrawerMenu(String label) async {
    await tapAndWait(find.byTooltip('Open navigation menu'), find.text(label));
    await pumpFor(const Duration(milliseconds: 500));
    await tap(find.text(label));
    await pumpFor(const Duration(milliseconds: 500));
  }

  Future<void> goBack() async {
    state<NavigatorState>(find.byType(Navigator)).pop();
    await pumpFor(const Duration(milliseconds: 800));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final watchlistButton = find.byType(FilledButton);
  final firstMoviePoster = find
      .descendant(
        of: find.byType(MoviePosterList),
        matching: find.byType(InkWell),
      )
      .first;
  final firstTvSeriesPoster = find
      .descendant(
        of: find.byType(TvSeriesPosterList),
        matching: find.byType(InkWell),
      )
      .first;

  setUpAll(() async {
    di.init(httpClient: await SslPinning.createClient());
  });

  Future<void> launchApp(WidgetTester tester) async {
    await tester.pumpWidget(const DitontonApp());
    await tester.pumpUntilFound(find.byType(MoviePosterList));
  }

  Future<void> ensureNotInWatchlist(WidgetTester tester) async {
    if (find.byIcon(Icons.check).evaluate().isNotEmpty) {
      await tester.tapAndWait(watchlistButton, find.byIcon(Icons.add));
      await tester.pumpFor(const Duration(seconds: 5));
    }
  }

  testWidgets('movie can be added to and removed from the watchlist', (
    tester,
  ) async {
    await launchApp(tester);

    await tester.tapAndWait(firstMoviePoster, watchlistButton);
    await ensureNotInWatchlist(tester);

    await tester.tapAndWait(
      watchlistButton,
      find.text(watchlistAddSuccessMessage),
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
    await tester.goBack();

    await tester.openDrawerMenu('Watchlist');
    await tester.pumpUntilFound(find.byType(MovieCard));
    expect(find.byType(WatchlistMoviesPage), findsOneWidget);

    await tester.tapAndWait(find.byType(MovieCard).first, watchlistButton);
    await tester.tapAndWait(
      watchlistButton,
      find.text(watchlistRemoveSuccessMessage),
    );
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.goBack();

    await tester.pumpFor(const Duration(seconds: 1));
    expect(find.byType(MovieCard), findsNothing);
  });

  testWidgets('movie search shows matching results', (tester) async {
    await launchApp(tester);

    await tester.tapAndWait(
      find.byIcon(Icons.search),
      find.byType(MovieSearchPage),
    );
    await tester.enterText(find.byType(TextField), 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    await tester.pumpUntilFound(find.byType(MovieCard));
    expect(find.byType(MovieCard), findsWidgets);
  });

  testWidgets('TV series detail shows seasons and their episodes', (
    tester,
  ) async {
    await launchApp(tester);

    await tester.openDrawerMenu('TV Series');
    await tester.pumpUntilFound(find.byType(TvSeriesPosterList));
    expect(find.byType(HomeTvSeriesPage), findsOneWidget);

    await tester.tapAndWait(firstTvSeriesPoster, find.byType(SeasonList));
    expect(find.textContaining('Seasons ('), findsOneWidget);

    final firstSeason = find
        .descendant(
          of: find.byType(SeasonList),
          matching: find.byType(ExpansionTile),
        )
        .first;
    await tester.ensureVisible(firstSeason);
    await tester.pumpFor(const Duration(milliseconds: 500));
    await tester.tap(firstSeason);

    await tester.pumpUntilFound(find.text('Episodes:'));
    expect(find.text('Failed to load episodes'), findsNothing);
  });

  testWidgets('TV series search shows matching results', (tester) async {
    await launchApp(tester);

    await tester.openDrawerMenu('TV Series');
    await tester.pumpUntilFound(find.byType(TvSeriesPosterList));

    await tester.tapAndWait(
      find.byIcon(Icons.search),
      find.byType(TvSeriesSearchPage),
    );
    await tester.enterText(find.byType(TextField), 'breaking bad');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    await tester.pumpUntilFound(find.byType(TvSeriesCard));
    expect(find.byType(TvSeriesCard), findsWidgets);
  });
}
