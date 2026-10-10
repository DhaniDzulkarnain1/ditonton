import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_tv_series_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(mockTvSeriesRepository);
  });

  const tId = 1;

  test('should get tv series detail from the repository', () async {
    when(
      () => mockTvSeriesRepository.getTvSeriesDetail(tId),
    ).thenAnswer((_) async => const Right(testTvSeriesDetail));
    final result = await usecase.execute(tId);
    expect(result, const Right(testTvSeriesDetail));
  });
}
