import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/domain/usecases/get_season_details.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  const tTvId = 1396;
  const tSeasonNumber = 1;

  late GetSeasonDetails usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetSeasonDetails(mockTvSeriesRepository);
  });

  test('should get season episodes from the repository', () async {
    when(
      () => mockTvSeriesRepository.getSeasonDetails(tTvId, tSeasonNumber),
    ).thenAnswer((_) async => const Right(testEpisodeList));

    final result = await usecase.execute(tTvId, tSeasonNumber);

    expect(result, const Right(testEpisodeList));
  });
}
