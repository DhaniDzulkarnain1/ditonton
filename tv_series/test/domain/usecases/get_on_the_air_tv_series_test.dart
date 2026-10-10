import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late GetOnTheAirTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetOnTheAirTvSeries(mockTvSeriesRepository);
  });

  final tTvSeriesList = <TvSeries>[];

  group('GetOnTheAirTvSeries Tests', () {
    group('execute', () {
      test(
        'should get list of tv series from the repository when execute function is called',
        () async {
          when(
            () => mockTvSeriesRepository.getOnTheAirTvSeries(),
          ).thenAnswer((_) async => Right(tTvSeriesList));
          final result = await usecase.execute();
          expect(result, Right(tTvSeriesList));
        },
      );
    });
  });
}
