import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late GetMovieRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieRecommendations(mockMovieRepository);
  });

  const tId = 1;
  final tMovies = <Movie>[];

  test(
    'should get list of movie recommendations from the repository',
    () async {
      when(
        () => mockMovieRepository.getMovieRecommendations(tId),
      ).thenAnswer((_) async => Right(tMovies));
      final result = await usecase.execute(tId);
      expect(result, Right(tMovies));
    },
  );
}
