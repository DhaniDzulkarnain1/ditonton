import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockGetPopularMovies usecase;
  late PopularMoviesBloc bloc;

  setUp(() {
    usecase = MockGetPopularMovies();
    bloc = PopularMoviesBloc(usecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, const MovieListEmpty());
  });

  blocTest<PopularMoviesBloc, MovieListState>(
    'should emit [loading, has data] when data is gotten successfully',
    build: () {
      when(
        () => usecase.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchPopularMovies()),
    expect: () => [const MovieListLoading(), MovieListHasData(testMovieList)],
    verify: (_) => verify(() => usecase.execute()).called(1),
  );

  blocTest<PopularMoviesBloc, MovieListState>(
    'should emit [loading, error] when getting data fails',
    build: () {
      when(
        () => usecase.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchPopularMovies()),
    expect: () => [
      const MovieListLoading(),
      const MovieListError('Server Failure'),
    ],
  );

  test('event should support value equality', () {
    expect(const FetchPopularMovies(), const FetchPopularMovies());
    expect(const FetchPopularMovies().props, isEmpty);
  });
}
