import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/presentation/bloc/movie_list_state.dart';

class FetchWatchlistMovies extends Equatable {
  const FetchWatchlistMovies();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesBloc extends Bloc<FetchWatchlistMovies, MovieListState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc(this.getWatchlistMovies) : super(const MovieListEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(const MovieListLoading());
      final result = await getWatchlistMovies.execute();
      emit(MovieListState.fromResult(result));
    });
  }
}
