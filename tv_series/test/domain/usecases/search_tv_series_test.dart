import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockTvSeriesRepository);
  });

  final tTvSeriesList = <TvSeries>[];
  const tQuery = 'Breaking Bad';

  test('should get list of tv series from the repository', () async {
    when(
      () => mockTvSeriesRepository.searchTvSeries(tQuery),
    ).thenAnswer((_) async => Right(tTvSeriesList));
    final result = await usecase.execute(tQuery);
    expect(result, Right(tTvSeriesList));
  });
}
