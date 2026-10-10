import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late GetTopRatedTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTopRatedTvSeries(mockTvSeriesRepository);
  });

  final tTvSeriesList = <TvSeries>[];

  group('GetTopRatedTvSeries Tests', () {
    group('execute', () {
      test(
        'should get list of tv series from the repository when execute function is called',
        () async {
          when(
            () => mockTvSeriesRepository.getTopRatedTvSeries(),
          ).thenAnswer((_) async => Right(tTvSeriesList));
          final result = await usecase.execute();
          expect(result, Right(tTvSeriesList));
        },
      );
    });
  });
}
