import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRpository);
  });

  final tMovies = <Movie>[];

  group('GetPopularMovies Tests', () {
    group('execute', () {
      test(
        'should get list of movies from the repository when execute function is called',
        () async {
          when(
            () => mockMovieRpository.getPopularMovies(),
          ).thenAnswer((_) async => Right(tMovies));
          final result = await usecase.execute();
          expect(result, Right(tMovies));
        },
      );
    });
  });
}
