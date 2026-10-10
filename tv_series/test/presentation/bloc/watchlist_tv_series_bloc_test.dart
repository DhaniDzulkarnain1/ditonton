import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockGetWatchlistTvSeries usecase;
  late WatchlistTvSeriesBloc bloc;

  setUp(() {
    usecase = MockGetWatchlistTvSeries();
    bloc = WatchlistTvSeriesBloc(usecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, const TvSeriesListEmpty());
  });

  blocTest<WatchlistTvSeriesBloc, TvSeriesListState>(
    'should emit [loading, has data] when data is gotten successfully',
    build: () {
      when(
        () => usecase.execute(),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistTvSeries()),
    expect: () => [
      const TvSeriesListLoading(),
      TvSeriesListHasData(testTvSeriesList),
    ],
    verify: (_) => verify(() => usecase.execute()).called(1),
  );

  blocTest<WatchlistTvSeriesBloc, TvSeriesListState>(
    'should emit [loading, error] when getting data fails',
    build: () {
      when(
        () => usecase.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistTvSeries()),
    expect: () => [
      const TvSeriesListLoading(),
      const TvSeriesListError('Server Failure'),
    ],
  );

  test('event should support value equality', () {
    expect(const FetchWatchlistTvSeries(), const FetchWatchlistTvSeries());
    expect(const FetchWatchlistTvSeries().props, isEmpty);
  });
}
