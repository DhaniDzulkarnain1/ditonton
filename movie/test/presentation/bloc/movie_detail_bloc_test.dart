import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mocks.dart';

void main() {
  const tId = 1;

  late MockGetMovieDetail getMovieDetail;
  late MockGetMovieRecommendations getMovieRecommendations;
  late MockGetWatchListStatus getWatchListStatus;
  late MockSaveWatchlist saveWatchlist;
  late MockRemoveWatchlist removeWatchlist;
  late MovieDetailBloc bloc;

  setUp(() {
    getMovieDetail = MockGetMovieDetail();
    getMovieRecommendations = MockGetMovieRecommendations();
    getWatchListStatus = MockGetWatchListStatus();
    saveWatchlist = MockSaveWatchlist();
    removeWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: getMovieDetail,
      getMovieRecommendations: getMovieRecommendations,
      getWatchListStatus: getWatchListStatus,
      saveWatchlist: saveWatchlist,
      removeWatchlist: removeWatchlist,
    );
  });

  void arrangeDetail({
    Either<Failure, MovieDetail>? detail,
    Either<Failure, List<Movie>>? recommendations,
    bool isAddedToWatchlist = false,
  }) {
    when(
      () => getMovieDetail.execute(tId),
    ).thenAnswer((_) async => detail ?? const Right(testMovieDetail));
    when(
      () => getMovieRecommendations.execute(tId),
    ).thenAnswer((_) async => recommendations ?? Right(testMovieList));
    when(
      () => getWatchListStatus.execute(tId),
    ).thenAnswer((_) async => isAddedToWatchlist);
  }

  test('initial state should be empty', () {
    expect(bloc.state, const MovieDetailState());
    expect(bloc.state.movieState, RequestState.empty);
  });

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit loading then loaded detail with recommendations',
      build: () {
        arrangeDetail(isAddedToWatchlist: true);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loaded,
          recommendations: testMovieList,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(() => getMovieDetail.execute(tId)).called(1);
        verify(() => getMovieRecommendations.execute(tId)).called(1);
        verify(() => getWatchListStatus.execute(tId)).called(1);
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit error when getting detail fails',
      build: () {
        arrangeDetail(detail: const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        const MovieDetailState(
          movieState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit loaded detail with recommendation error',
      build: () {
        arrangeDetail(
          recommendations: const Left(ConnectionFailure('No Connection')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        const MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.error,
          message: 'No Connection',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit success message and added status when saving succeeds',
      build: () {
        when(
          () => saveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right(watchlistAddSuccessMessage));
        when(
          () => getWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => const MovieDetailState(watchlistMessage: 'previous'),
      act: (bloc) => bloc.add(const AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(),
        const MovieDetailState(
          watchlistMessage: watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) => verify(() => saveWatchlist.execute(testMovieDetail)),
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should re-emit the failure message when saving fails again',
      build: () {
        when(
          () => saveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(
          () => getWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const MovieDetailState(watchlistMessage: 'Failed'),
      act: (bloc) => bloc.add(const AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(),
        const MovieDetailState(watchlistMessage: 'Failed'),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit success message and removed status when removing succeeds',
      build: () {
        when(
          () => removeWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right(watchlistRemoveSuccessMessage));
        when(
          () => getWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const MovieDetailState(isAddedToWatchlist: true),
      act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(watchlistMessage: watchlistRemoveSuccessMessage),
      ],
      verify: (_) => verify(() => removeWatchlist.execute(testMovieDetail)),
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit failure message when removing fails',
      build: () {
        when(
          () => removeWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(
          () => getWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => const MovieDetailState(isAddedToWatchlist: true),
      act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(
          watchlistMessage: 'Failed',
          isAddedToWatchlist: true,
        ),
      ],
    );
  });

  test('events should support value equality', () {
    expect(const FetchMovieDetail(tId), const FetchMovieDetail(tId));
    expect(
      const AddMovieToWatchlist(testMovieDetail),
      const AddMovieToWatchlist(testMovieDetail),
    );
    expect(
      const RemoveMovieFromWatchlist(testMovieDetail),
      const RemoveMovieFromWatchlist(testMovieDetail),
    );
  });
}
