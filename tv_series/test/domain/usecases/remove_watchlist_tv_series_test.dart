import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late RemoveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    when(
      () => mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Removed from watchlist'));
    final result = await usecase.execute(testTvSeriesDetail);
    verify(() => mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
