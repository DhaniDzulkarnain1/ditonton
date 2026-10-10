import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/bloc/movie_list_state.dart';

class FetchPopularMovies extends Equatable {
  const FetchPopularMovies();

  @override
  List<Object> get props => [];
}

class PopularMoviesBloc extends Bloc<FetchPopularMovies, MovieListState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(const MovieListEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(const MovieListLoading());
      final result = await getPopularMovies.execute();
      emit(MovieListState.fromResult(result));
    });
  }
}
