import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  const tQuery = 'breaking bad';

  late MockSearchTvSeries searchTvSeries;
  late TvSeriesSearchBloc bloc;

  setUp(() {
    searchTvSeries = MockSearchTvSeries();
    bloc = TvSeriesSearchBloc(searchTvSeries);
  });

  test('initial state should be empty', () {
    expect(bloc.state, const TvSeriesListEmpty());
  });

  blocTest<TvSeriesSearchBloc, TvSeriesListState>(
    'should emit [loading, has data] when search succeeds',
    build: () {
      when(
        () => searchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(const TvSeriesSearchSubmitted(tQuery)),
    expect: () => [
      const TvSeriesListLoading(),
      TvSeriesListHasData(testTvSeriesList),
    ],
    verify: (_) => verify(() => searchTvSeries.execute(tQuery)).called(1),
  );

  blocTest<TvSeriesSearchBloc, TvSeriesListState>(
    'should emit [loading, error] when search fails',
    build: () {
      when(
        () => searchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const TvSeriesSearchSubmitted(tQuery)),
    expect: () => [
      const TvSeriesListLoading(),
      const TvSeriesListError('Server Failure'),
    ],
  );

  test('event should support value equality', () {
    expect(
      const TvSeriesSearchSubmitted(tQuery),
      const TvSeriesSearchSubmitted(tQuery),
    );
  });
}
