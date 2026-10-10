import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddMovieToWatchlist>(_onAddMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveMovieFromWatchlist);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(const MovieDetailState(movieState: RequestState.loading));

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );
    final isAddedToWatchlist = await getWatchListStatus.execute(event.id);

    detailResult.fold(
      (failure) => emit(
        state.copyWith(
          movieState: RequestState.error,
          message: failure.message,
        ),
      ),
      (movie) {
        final loaded = state.copyWith(
          movieState: RequestState.loaded,
          movie: movie,
          isAddedToWatchlist: isAddedToWatchlist,
        );
        emit(
          recommendationResult.fold(
            (failure) => loaded.copyWith(
              recommendationState: RequestState.error,
              message: failure.message,
            ),
            (movies) => loaded.copyWith(
              recommendationState: RequestState.loaded,
              recommendations: movies,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddMovieToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(watchlistMessage: ''));
    final result = await saveWatchlist.execute(event.movie);
    await _emitWatchlistResult(result, event.movie.id, emit);
  }

  Future<void> _onRemoveMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(watchlistMessage: ''));
    final result = await removeWatchlist.execute(event.movie);
    await _emitWatchlistResult(result, event.movie.id, emit);
  }

  Future<void> _emitWatchlistResult(
    Either<Failure, String> result,
    int id,
    Emitter<MovieDetailState> emit,
  ) async {
    final message = result.fold((failure) => failure.message, (text) => text);
    final isAddedToWatchlist = await getWatchListStatus.execute(id);
    emit(
      state.copyWith(
        watchlistMessage: message,
        isAddedToWatchlist: isAddedToWatchlist,
      ),
    );
  }
}
