import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  const tId = 1;

  late MockGetTvSeriesDetail getTvSeriesDetail;
  late MockGetTvSeriesRecommendations getTvSeriesRecommendations;
  late MockGetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  late MockSaveWatchlistTvSeries saveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries removeWatchlistTvSeries;
  late TvSeriesDetailBloc bloc;

  setUp(() {
    getTvSeriesDetail = MockGetTvSeriesDetail();
    getTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    getWatchlistStatusTvSeries = MockGetWatchlistStatusTvSeries();
    saveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    removeWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    bloc = TvSeriesDetailBloc(
      getTvSeriesDetail: getTvSeriesDetail,
      getTvSeriesRecommendations: getTvSeriesRecommendations,
      getWatchlistStatusTvSeries: getWatchlistStatusTvSeries,
      saveWatchlistTvSeries: saveWatchlistTvSeries,
      removeWatchlistTvSeries: removeWatchlistTvSeries,
    );
  });

  void arrangeDetail({
    Either<Failure, TvSeriesDetail>? detail,
    Either<Failure, List<TvSeries>>? recommendations,
    bool isAddedToWatchlist = false,
  }) {
    when(
      () => getTvSeriesDetail.execute(tId),
    ).thenAnswer((_) async => detail ?? const Right(testTvSeriesDetail));
    when(
      () => getTvSeriesRecommendations.execute(tId),
    ).thenAnswer((_) async => recommendations ?? Right(testTvSeriesList));
    when(
      () => getWatchlistStatusTvSeries.execute(tId),
    ).thenAnswer((_) async => isAddedToWatchlist);
  }

  test('initial state should be empty', () {
    expect(bloc.state, const TvSeriesDetailState());
    expect(bloc.state.tvSeriesState, RequestState.empty);
  });

  group('FetchTvSeriesDetail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit loading then loaded detail with recommendations',
      build: () {
        arrangeDetail(isAddedToWatchlist: true);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.loading),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: testTvSeriesList,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(() => getTvSeriesDetail.execute(tId)).called(1);
        verify(() => getTvSeriesRecommendations.execute(tId)).called(1);
        verify(() => getWatchlistStatusTvSeries.execute(tId)).called(1);
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit error when getting detail fails',
      build: () {
        arrangeDetail(detail: const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.loading),
        const TvSeriesDetailState(
          tvSeriesState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit loaded detail with recommendation error',
      build: () {
        arrangeDetail(
          recommendations: const Left(ConnectionFailure('No Connection')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.loading),
        const TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.error,
          message: 'No Connection',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit success message and added status when saving succeeds',
      build: () {
        when(
          () => saveWatchlistTvSeries.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => const Right(watchlistAddSuccessMessage));
        when(
          () => getWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => const TvSeriesDetailState(watchlistMessage: 'previous'),
      act: (bloc) => bloc.add(const AddTvSeriesToWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(),
        const TvSeriesDetailState(
          watchlistMessage: watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) =>
          verify(() => saveWatchlistTvSeries.execute(testTvSeriesDetail)),
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should re-emit the failure message when saving fails again',
      build: () {
        when(
          () => saveWatchlistTvSeries.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(
          () => getWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const TvSeriesDetailState(watchlistMessage: 'Failed'),
      act: (bloc) => bloc.add(const AddTvSeriesToWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(),
        const TvSeriesDetailState(watchlistMessage: 'Failed'),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit success message and removed status when removing succeeds',
      build: () {
        when(
          () => removeWatchlistTvSeries.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => const Right(watchlistRemoveSuccessMessage));
        when(
          () => getWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const TvSeriesDetailState(isAddedToWatchlist: true),
      act: (bloc) =>
          bloc.add(const RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: watchlistRemoveSuccessMessage,
        ),
      ],
      verify: (_) =>
          verify(() => removeWatchlistTvSeries.execute(testTvSeriesDetail)),
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit failure message when removing fails',
      build: () {
        when(
          () => removeWatchlistTvSeries.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(
          () => getWatchlistStatusTvSeries.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => const TvSeriesDetailState(isAddedToWatchlist: true),
      act: (bloc) =>
          bloc.add(const RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
          watchlistMessage: 'Failed',
          isAddedToWatchlist: true,
        ),
      ],
    );
  });

  test('events should support value equality', () {
    expect(const FetchTvSeriesDetail(tId), const FetchTvSeriesDetail(tId));
    expect(
      const AddTvSeriesToWatchlist(testTvSeriesDetail),
      const AddTvSeriesToWatchlist(testTvSeriesDetail),
    );
    expect(
      const RemoveTvSeriesFromWatchlist(testTvSeriesDetail),
      const RemoveTvSeriesFromWatchlist(testTvSeriesDetail),
    );
  });
}
