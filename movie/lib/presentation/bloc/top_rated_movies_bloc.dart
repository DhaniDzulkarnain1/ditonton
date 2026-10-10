import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_list_state.dart';

class FetchTopRatedMovies extends Equatable {
  const FetchTopRatedMovies();

  @override
  List<Object> get props => [];
}

class TopRatedMoviesBloc extends Bloc<FetchTopRatedMovies, MovieListState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies) : super(const MovieListEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(const MovieListLoading());
      final result = await getTopRatedMovies.execute();
      emit(MovieListState.fromResult(result));
    });
  }
}
