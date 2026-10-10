import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/widgets/season_list.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  const tTvSeriesId = 1;
  const tSeason = Season(
    airDate: '2008-01-20',
    episodeCount: 7,
    id: 3572,
    name: 'Season 1',
    overview: 'The first season.',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  late MockSeasonEpisodesBloc bloc;

  setUp(() {
    bloc = MockSeasonEpisodesBloc();
  });

  Future<void> pumpSeasonList(
    WidgetTester tester, {
    Season season = tSeason,
    SeasonEpisodesState state = const SeasonEpisodesState(),
    bool expand = true,
  }) async {
    when(() => bloc.state).thenReturn(state);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: SeasonList(tvSeriesId: tTvSeriesId, seasons: [season]),
        ),
      ),
      providers: [BlocProvider<SeasonEpisodesBloc>.value(value: bloc)],
    );
    if (expand) {
      await tester.tap(find.text(season.name));
      await tester.pumpTransition();
    }
  }

  SeasonEpisodesState stateWith(SeasonEpisodes season, {int? tvSeriesId}) {
    return SeasonEpisodesState(
      tvSeriesId: tvSeriesId ?? tTvSeriesId,
      seasons: {tSeason.seasonNumber: season},
    );
  }

  SeasonEpisodesState loadedWith(Episode episode) {
    return stateWith(
      SeasonEpisodes(requestState: RequestState.loaded, episodes: [episode]),
    );
  }

  testWidgets('should display season name and episode count', (tester) async {
    await pumpSeasonList(tester, expand: false);

    expect(find.text('Season 1'), findsOneWidget);
    expect(find.text('7 episodes'), findsOneWidget);
    verifyNever(() => bloc.add(const FetchSeasonEpisodes(tTvSeriesId, 1)));
  });

  testWidgets('should fetch episodes when a season is expanded', (
    tester,
  ) async {
    await pumpSeasonList(tester);

    verify(() => bloc.add(const FetchSeasonEpisodes(tTvSeriesId, 1))).called(1);
    expect(find.text('Air Date: 2008-01-20'), findsOneWidget);
    expect(find.text('The first season.'), findsOneWidget);
  });

  testWidgets('should not fetch episodes when a season is collapsed', (
    tester,
  ) async {
    await pumpSeasonList(tester);

    await tester.tap(find.text('Season 1'));
    await tester.pumpTransition();

    verify(() => bloc.add(const FetchSeasonEpisodes(tTvSeriesId, 1))).called(1);
  });

  testWidgets('should display fallback text when season has no detail', (
    tester,
  ) async {
    const season = Season(
      airDate: null,
      episodeCount: 0,
      id: 1,
      name: 'Specials',
      overview: '',
      posterPath: null,
      seasonNumber: 0,
    );

    await pumpSeasonList(tester, season: season);

    expect(find.textContaining('Air Date'), findsNothing);
    expect(find.text('No overview available'), findsOneWidget);
  });

  testWidgets('should display progress bar when episodes are loading', (
    tester,
  ) async {
    await pumpSeasonList(
      tester,
      state: stateWith(
        const SeasonEpisodes(requestState: RequestState.loading),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display message when episodes fail to load', (
    tester,
  ) async {
    await pumpSeasonList(
      tester,
      state: stateWith(const SeasonEpisodes(requestState: RequestState.error)),
    );

    expect(find.text('Failed to load episodes'), findsOneWidget);
  });

  testWidgets('should display episodes when they are loaded', (tester) async {
    await pumpSeasonList(tester, state: loadedWith(testEpisode));

    expect(find.text('Episodes:'), findsOneWidget);
    expect(find.text('1. Pilot'), findsOneWidget);
    expect(find.text(testEpisode.overview), findsOneWidget);
    expect(find.text('8.2'), findsOneWidget);
  });

  testWidgets('should ignore episodes that belong to another TV series', (
    tester,
  ) async {
    await pumpSeasonList(
      tester,
      state: stateWith(
        const SeasonEpisodes(
          requestState: RequestState.loaded,
          episodes: testEpisodeList,
        ),
        tvSeriesId: 99,
      ),
    );

    expect(find.text('1. Pilot'), findsNothing);
  });

  testWidgets('should display fallbacks when episode has no detail', (
    tester,
  ) async {
    const episode = Episode(
      airDate: null,
      episodeNumber: 2,
      id: 2,
      name: 'Untitled',
      overview: '',
      stillPath: null,
      voteAverage: 0,
    );

    await pumpSeasonList(tester, state: loadedWith(episode));

    expect(find.text('2. Untitled'), findsOneWidget);
    expect(find.text('No overview available'), findsOneWidget);
    expect(find.byIcon(Icons.image), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('should truncate long episode overview', (tester) async {
    final overview = 'a' * 150;
    final episode = Episode(
      airDate: null,
      episodeNumber: 3,
      id: 3,
      name: 'Long',
      overview: overview,
      stillPath: null,
      voteAverage: 7,
    );

    await pumpSeasonList(tester, state: loadedWith(episode));

    expect(find.text('${'a' * 100}...'), findsOneWidget);
  });
}
