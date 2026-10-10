import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  const tQuery = 'spiderman';

  late MockSearchMovies searchMovies;
  late MovieSearchBloc bloc;

  setUp(() {
    searchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(searchMovies);
  });

  test('initial state should be empty', () {
    expect(bloc.state, const MovieListEmpty());
  });

  blocTest<MovieSearchBloc, MovieListState>(
    'should emit [loading, has data] when search succeeds',
    build: () {
      when(
        () => searchMovies.execute(tQuery),
      ).thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(const MovieSearchSubmitted(tQuery)),
    expect: () => [const MovieListLoading(), MovieListHasData(testMovieList)],
    verify: (_) => verify(() => searchMovies.execute(tQuery)).called(1),
  );

  blocTest<MovieSearchBloc, MovieListState>(
    'should emit [loading, error] when search fails',
    build: () {
      when(
        () => searchMovies.execute(tQuery),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const MovieSearchSubmitted(tQuery)),
    expect: () => [
      const MovieListLoading(),
      const MovieListError('Server Failure'),
    ],
  );

  test('event should support value equality', () {
    expect(
      const MovieSearchSubmitted(tQuery),
      const MovieSearchSubmitted(tQuery),
    );
  });
}
