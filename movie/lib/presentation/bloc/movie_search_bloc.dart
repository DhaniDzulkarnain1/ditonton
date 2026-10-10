import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/movie_list_state.dart';

class MovieSearchSubmitted extends Equatable {
  final String query;

  const MovieSearchSubmitted(this.query);

  @override
  List<Object> get props => [query];
}

class MovieSearchBloc extends Bloc<MovieSearchSubmitted, MovieListState> {
  final SearchMovies searchMovies;

  MovieSearchBloc(this.searchMovies) : super(const MovieListEmpty()) {
    on<MovieSearchSubmitted>((event, emit) async {
      emit(const MovieListLoading());
      final result = await searchMovies.execute(event.query);
      emit(MovieListState.fromResult(result));
    });
  }
}
