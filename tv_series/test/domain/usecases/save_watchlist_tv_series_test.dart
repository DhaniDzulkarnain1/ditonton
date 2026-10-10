import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    when(
      () => mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    final result = await usecase.execute(testTvSeriesDetail);
    verify(() => mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
