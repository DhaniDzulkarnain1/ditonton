import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(mockTvSeriesRepository);
  });

  const tId = 1;
  final tTvSeriesList = <TvSeries>[];

  test(
    'should get list of tv series recommendations from the repository',
    () async {
      when(
        () => mockTvSeriesRepository.getTvSeriesRecommendations(tId),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      final result = await usecase.execute(tId);
      expect(result, Right(tTvSeriesList));
    },
  );
}
