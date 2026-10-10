import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/movie_list_state.dart';

class FetchNowPlayingMovies extends Equatable {
  const FetchNowPlayingMovies();

  @override
  List<Object> get props => [];
}

class NowPlayingMoviesBloc extends Bloc<FetchNowPlayingMovies, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc(this.getNowPlayingMovies)
    : super(const MovieListEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(const MovieListLoading());
      final result = await getNowPlayingMovies.execute();
      emit(MovieListState.fromResult(result));
    });
  }
}
