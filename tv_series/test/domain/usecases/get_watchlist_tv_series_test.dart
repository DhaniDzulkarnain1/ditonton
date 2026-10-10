import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should get list of tv series from the repository', () async {
    when(
      () => mockTvSeriesRepository.getWatchlistTvSeries(),
    ).thenAnswer((_) async => Right(testTvSeriesList));
    final result = await usecase.execute();
    expect(result, Right(testTvSeriesList));
  });
}
