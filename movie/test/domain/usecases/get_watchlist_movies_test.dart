import 'package:dartz/dartz.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late GetWatchlistMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlistMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    when(
      () => mockMovieRepository.getWatchlistMovies(),
    ).thenAnswer((_) async => Right(testMovieList));
    final result = await usecase.execute();
    expect(result, Right(testMovieList));
  });
}
