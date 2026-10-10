import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  const tTvSeriesId = 1;
  const tSeasonNumber = 1;
  const tLoading = SeasonEpisodes(requestState: RequestState.loading);
  const tLoaded = SeasonEpisodes(
    requestState: RequestState.loaded,
    episodes: testEpisodeList,
  );

  late MockGetSeasonDetails getSeasonDetails;
  late SeasonEpisodesBloc bloc;

  setUp(() {
    getSeasonDetails = MockGetSeasonDetails();
    bloc = SeasonEpisodesBloc(getSeasonDetails);
  });

  SeasonEpisodesState stateWith(
    Map<int, SeasonEpisodes> seasons, {
    int tvSeriesId = tTvSeriesId,
  }) {
    return SeasonEpisodesState(tvSeriesId: tvSeriesId, seasons: seasons);
  }

  test('initial state should have no seasons', () {
    expect(bloc.state, const SeasonEpisodesState());
    expect(bloc.state.season(tSeasonNumber), const SeasonEpisodes());
  });

  blocTest<SeasonEpisodesBloc, SeasonEpisodesState>(
    'should emit [loading, loaded] when episodes are gotten successfully',
    build: () {
      when(
        () => getSeasonDetails.execute(tTvSeriesId, tSeasonNumber),
      ).thenAnswer((_) async => const Right(testEpisodeList));
      return bloc;
    },
    act: (bloc) =>
        bloc.add(const FetchSeasonEpisodes(tTvSeriesId, tSeasonNumber)),
    expect: () => [
      stateWith({tSeasonNumber: tLoading}),
      stateWith({tSeasonNumber: tLoaded}),
    ],
    verify: (_) {
      verify(
        () => getSeasonDetails.execute(tTvSeriesId, tSeasonNumber),
      ).called(1);
    },
  );

  blocTest<SeasonEpisodesBloc, SeasonEpisodesState>(
    'should emit [loading, error] when getting episodes fails',
    build: () {
      when(
        () => getSeasonDetails.execute(tTvSeriesId, tSeasonNumber),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) =>
        bloc.add(const FetchSeasonEpisodes(tTvSeriesId, tSeasonNumber)),
    expect: () => [
      stateWith({tSeasonNumber: tLoading}),
      stateWith({
        tSeasonNumber: const SeasonEpisodes(
          requestState: RequestState.error,
          message: 'Server Failure',
        ),
      }),
    ],
  );

  blocTest<SeasonEpisodesBloc, SeasonEpisodesState>(
    'should not fetch again when the season is already loaded',
    build: () => bloc,
    seed: () => stateWith({tSeasonNumber: tLoaded}),
    act: (bloc) =>
        bloc.add(const FetchSeasonEpisodes(tTvSeriesId, tSeasonNumber)),
    expect: () => <SeasonEpisodesState>[],
    verify: (_) => verifyZeroInteractions(getSeasonDetails),
  );

  blocTest<SeasonEpisodesBloc, SeasonEpisodesState>(
    'should keep other seasons of the same TV series',
    build: () {
      when(
        () => getSeasonDetails.execute(tTvSeriesId, 2),
      ).thenAnswer((_) async => const Right(testEpisodeList));
      return bloc;
    },
    seed: () => stateWith({tSeasonNumber: tLoaded}),
    act: (bloc) => bloc.add(const FetchSeasonEpisodes(tTvSeriesId, 2)),
    expect: () => [
      stateWith({tSeasonNumber: tLoaded, 2: tLoading}),
      stateWith({tSeasonNumber: tLoaded, 2: tLoaded}),
    ],
  );

  blocTest<SeasonEpisodesBloc, SeasonEpisodesState>(
    'should discard cached seasons when another TV series is opened',
    build: () {
      when(
        () => getSeasonDetails.execute(2, tSeasonNumber),
      ).thenAnswer((_) async => const Right(testEpisodeList));
      return bloc;
    },
    seed: () => stateWith({tSeasonNumber: tLoaded, 2: tLoaded}),
    act: (bloc) => bloc.add(const FetchSeasonEpisodes(2, tSeasonNumber)),
    expect: () => [
      stateWith({tSeasonNumber: tLoading}, tvSeriesId: 2),
      stateWith({tSeasonNumber: tLoaded}, tvSeriesId: 2),
    ],
  );

  test('event should support value equality', () {
    expect(
      const FetchSeasonEpisodes(tTvSeriesId, tSeasonNumber),
      const FetchSeasonEpisodes(tTvSeriesId, tSeasonNumber),
    );
  });
}
