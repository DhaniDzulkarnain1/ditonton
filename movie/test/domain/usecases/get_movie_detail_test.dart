import 'package:dartz/dartz.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late GetMovieDetail usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieDetail(mockMovieRepository);
  });

  const tId = 1;

  test('should get movie detail from the repository', () async {
    when(
      () => mockMovieRepository.getMovieDetail(tId),
    ).thenAnswer((_) async => const Right(testMovieDetail));
    final result = await usecase.execute(tId);
    expect(result, const Right(testMovieDetail));
  });
}
